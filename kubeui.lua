-- KubeUI
local function embed()
    local e = {initialized=false, shared_data={}, internal={}}
    local t = {}
    local a = table.concat
    local o = {{2,3,4,5,6},{4,1,6,3,5},{1,4,5,2,6},{2,6,3,5,1},{3,6,1,4,2},{4,5,2,3,1}}
    local function r(d,l,u,c,m,f) return l*1+u*3+c*4+m*20+f*100 end
    -- Load lookups
    local function B(G,K,Q) return math.floor(G/(K^Q)) end
    local J = 0
    local function X()
        local h,i,n = e.internal.to_blit_lookup,e.internal.texel_character_lookup,e.internal.texel_foreground_lookup
        for Z=0,15 do h[2^Z] = ("%x"):format(Z) end
    end
    e.internal.generate_lookups=X
    function e.new(Ca,Ma,Fa)
        local Wa = {modules={module_functions={}}}
        Wa.background = Ma or colors.black
        local Ya,Pa = Ca.getSize()
        Wa.term = Ca
        setmetatable(Wa, {__index=function(Va,Ba)
            local Ga = rawget(Wa.modules.module_functions,Ba)
            if Ga then return Wa.modules[Ga.id].__fn[Ga.name] end
            return rawget(t,Ba)
        end})
        Wa.__pixelbox_lite = true
        Wa.term_width = Ya
        Wa.term_height = Pa
        Wa.width = Ya*2
        Wa.height = Pa*3
        Wa.x_offset = 0
        Wa.y_offset = 0
        e.restore(Wa,Wa.background)
        if type(Fa)=="table" then Wa:load_module(Fa) end
        if not e.initialized then X() e.initialized=true end
        return Wa
    end
    return e
end

-- GUI manager
local gui = {}
gui.pixelbox = embed()
gui.components = {}
gui.activeComponents = {}

-- Color palette
gui.colors = {
    primary = colors.blue,
    secondary = colors.lightBlue,
    success = colors.green,
    danger = colors.red,
    warning = colors.orange,
    text = colors.white,
    textDark = colors.gray,
    background = colors.black,
    border = colors.gray,
    disabled = colors.lightGray
}

local fontMode = "pixel" -- "pixel" or "cc"

function gui.setFont(mode)
    if mode == "pixel" or mode == "cc" then
        fontMode = mode
        log("CODE", colors.green, "Changed font to "..mode..".")
    else
        error("Invalid font mode: " .. tostring(mode))
    end
end

-- Logging system
local logEnabled = false
local logMon = term.native()
function log(type, color, text)
    if logEnabled then
        local tmp = term.redirect(logMon)
        local prev = term.getTextColor()
        term.setTextColor(color)
        print("["..type.."] "..text)
        term.setTextColor(prev)
        term.redirect(tmp)
    end
end

function gui.log(screen, enabled)
    logMon = screen or term.native()
    logEnabled = enabled or false
end

-- Helper functions
local function isInBounds(x, y, bx, by, bw, bh)
    return x >= bx and x < bx + bw and y >= by and y < by + bh
end

local function drawFilledRect(box, x, y, w, h, col)
    for py=y,y+h-1 do
        for px=x,x+w-1 do
            if px>=1 and px<=box.width and py>=1 and py<=box.height then
                box:set_pixel(px, py, col)
            end
        end
    end
end

local function drawRect(box, x, y, w, h, col)
    for px=x,x+w-1 do
        if px>=1 and px<=box.width then
            if y>=1 and y<=box.height then box:set_pixel(px,y,col) end
            if y+h-1>=1 and y+h-1<=box.height then box:set_pixel(px,y+h-1,col) end
        end
    end
    for py=y,y+h-1 do
        if py>=1 and py<=box.height then
            if x>=1 and x<=box.width then box:set_pixel(x,py,col) end
            if x+w-1>=1 and x+w-1<=box.width then box:set_pixel(x+w-1,py,col) end
        end
    end
end

-- Draw Text
local function drawText(box, x, y, text, textCol, scale)
    scale = scale or 1
    if fontMode == "cc" then
        -- CC mode: pick dominant background from pixels
        local bgCounts = {}
        for i=1,#text do
            local c = text:sub(i,i)
            local col = textCol or colors.white
            bgCounts[col] = (bgCounts[col] or 0)+1
        end
        local bgCol,bgMax = colors.black,0
        for k,v in pairs(bgCounts) do
            if v>bgMax then bgCol,k=v,k end
        end
        term.setBackgroundColor(bgCol)
        term.setTextColor(textCol or colors.white)
        term.write(text)
        return #text*6
    else
        -- Pixel font (simplified, 5x3)
        local chars = {
            ["A"]={{1,1,1},{1,0,1},{1,1,1},{1,0,1},{1,0,1}},
            ["B"]={{1,1,0},{1,0,1},{1,1,0},{1,0,1},{1,1,0}},
            [" "]={{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0}}
        }
        local cx = x
        for i=1,#text do
            local c = text:sub(i,i):upper()
            local char = chars[c]
            if char then
                for row=1,5 do
                    for col=1,3 do
                        if char[row][col]==1 then
                            for sy=0,scale-1 do
                                for sx=0,scale-1 do
                                    local px = cx + (col-1)*scale + sx
                                    local py = y + (row-1)*scale + sy
                                    if px>=1 and px<=box.width and py>=1 and py<=box.height then
                                        box:set_pixel(px,py,textCol)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            cx = cx + 4*scale
        end
        return cx - x
    end
end

-- GUI Components

function gui.Button(x, y, w, h, text, callback)
    local btn = {
        type="button", x=x, y=y, w=w, h=h,
        text=text or "Button",
        callback=callback or function() end,
        enabled=true, hovered=false, pressed=false,
        bgColor=gui.colors.primary, textColor=gui.colors.text,
        hoverColor=gui.colors.secondary
    }
    function btn:render(box)
        local col = self.enabled and (self.hovered and self.hoverColor or self.bgColor) or gui.colors.disabled
        drawFilledRect(box, self.x, self.y, self.w, self.h, col)
        drawRect(box, self.x, self.y, self.w, self.h, gui.colors.border)
        local textW = #self.text * 4
        local tx = self.x + math.floor((self.w - textW)/2)
        local ty = self.y + math.floor(self.h/2)-2
        drawText(box, tx, ty, self.text, self.textColor)
    end
    function btn:handleClick(mx,my,button)
        if not self.enabled then return false end
        if button==1 and isInBounds(mx,my,self.x,self.y,self.w,self.h) then
            self.pressed=true
            self:callback()
            return true
        end
        return false
    end
    function btn:handleMouse(mx,my)
        self.hovered = isInBounds(mx,my,self.x,self.y,self.w,self.h) and self.enabled
    end
    log("CODE", colors.green, "Added a Button.")
    return btn
end

function gui.Label(x, y, text, color)
    local label = {type="label", x=x, y=y, text=text or "", textColor=color or gui.colors.text, scale=1}
    function label:render(box)
        drawText(box, self.x, self.y, self.text, self.textColor, self.scale)
    end
    function label:setText(text) self.text=text end
    log("CODE", colors.green, "Added a label.")
    return label
end

function gui.Checkbox(x,y,label,checked,callback)
    local cb = {type="checkbox", x=x, y=y, label=label or "", checked=checked or false, callback=callback or function() end, enabled=true, size=8}
    function cb:render(box)
        drawRect(box, self.x,self.y,self.size,self.size,self.enabled and gui.colors.border or gui.colors.disabled)
        if self.checked then
            drawFilledRect(box,self.x+2,self.y+2,self.size-4,self.size-4,gui.colors.success)
        end
        if self.label~="" then drawText(box,self.x+self.size+4,self.y+1,self.label,gui.colors.text) end
    end
    function cb:handleClick(mx,my,button)
        if not self.enabled then return false end
        if button==1 and isInBounds(mx,my,self.x,self.y,self.size,self.size) then
            self.checked = not self.checked
            self:callback(self.checked)
            return true
        end
        return false
    end
    log("CODE", colors.green, "Added a Checkbox")
    return cb
end

function gui.Slider(x,y,w,min,max,value,callback)
    local slider = {type="slider", x=x, y=y, w=w, h=6, min=min or 0, max=max or 100, value=value or min or 0, callback=callback or function() end, enabled=true, dragging=false}
    function slider:render(box)
        drawFilledRect(box,self.x,self.y+2,self.w,2,gui.colors.border)
        local percent = (self.value-self.min)/(self.max-self.min)
        local handleX = self.x+math.floor(percent*(self.w-4))
        drawFilledRect(box, handleX, self.y,4,self.h,self.enabled and gui.colors.primary or gui.colors.disabled)
    end
    function slider:handleClick(mx,my,button)
        if not self.enabled then return false end
        if button==1 and isInBounds(mx,my,self.x,self.y,self.w,self.h) then
            self.dragging=true
            self:updateValue(mx)
            return true
        end
        return false
    end
    function slider:handleDrag(mx,my)
        if self.dragging then self:updateValue(mx) end
    end
    function slider:handleRelease() self.dragging=false end
    function slider:updateValue(mx)
        local percent = math.max(0,math.min(1,(mx-self.x)/self.w))
        self.value=self.min+percent*(self.max-self.min)
        self:callback(self.value)
    end
    log("CODE", colors.green, "Added a Slider.")
    return slider
end

-- GUI Manager
function gui.new(term_obj)
    local box = gui.pixelbox.new(term_obj or term.current())
    local manager = {box=box, components={}, mouseDown=false}
    function manager:add(comp)
        table.insert(self.components,comp)
        return comp
    end
    function manager:render()
        self.box:clear()
        for _,c in ipairs(self.components) do c:render(self.box) end
        self.box:render()
    end
    function manager:handleEvent(event)
        if event[1]=="mouse_click" then
            local mx,my = (event[3]-1)*2+1,(event[4]-1)*3+1
            local button=event[2]
            for i=#self.components,1,-1 do
                local comp=self.components[i]
                if comp.handleClick and comp:handleClick(mx,my,button) then self.mouseDown=true break end
            end
            self:render()
        elseif event[1]=="mouse_drag" then
            local mx,my=(event[3]-1)*2+1,(event[4]-1)*3+1
            for _,c in ipairs(self.components) do
                if c.handleDrag then c:handleDrag(mx,my) end
                if c.handleMouse then c:handleMouse(mx,my) end
            end
            self:render()
        elseif event[1]=="mouse_up" then
            for _,c in ipairs(self.components) do if c.handleRelease then c:handleRelease() end end
            self.mouseDown=false
            self:render()
        elseif event[1]=="term_resize" then
            local w,h=self.box.term.getSize()
            self.box:resize(w,h)
            self:render()
        end
    end
    function manager:run()
        self:render()
        while true do
            local ev={os.pullEvent()}
            self:handleEvent(ev)
        end
    end
    return manager
end

return gui
