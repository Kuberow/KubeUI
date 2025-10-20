-- KubeUI
local function embed()
    local e={initialized=false,shared_data={},internal={}}local t={}local
    a=table.concat local
    o={{2,3,4,5,6},{4,1,6,3,5},{1,4,5,2,6},{2,6,3,5,1},{3,6,1,4,2},{4,5,2,3,1}}local
    i=load("return {"..string.rep("false,",599).."[0]=false}","=pb_preload","t")()local
    n=load("return {"..string.rep("false,",599).."[0]=false}","=pb_preload","t")()local
    s=load("return {"..string.rep("false,",599).."[0]=false}","=pb_preload","t")()local
    h={}e.internal.texel_character_lookup=i e.internal.texel_foreground_lookup=n
    e.internal.texel_background_lookup=s e.internal.to_blit_lookup=h
    e.internal.sampling_lookup=o local function r(d,l,u,c,m,f)return
    l*1+u*3+c*4+m*20+f*100 end local function w(y,p,v,b,g,k)local
    q={y,p,v,b,g,k}local j={}for x=1,6 do local z=q[x]local E=j[z]j[z]=E and E+1 or
    1 end local T={}for A,O in pairs(j)do T[#T+1]={value=A,count=O}end
    table.sort(T,function(I,N)return I.count>N.count end)local S={}for H=1,6 do
    local R=q[H]if R==T[1].value then S[H]=1 elseif R==T[2].value then S[H]=0 else
    local D=o[H]for L=1,5 do local U=D[L]local C=q[U]local M=C==T[1].value local
    F=C==T[2].value if M or F then S[H]=M and 1 or 0 break end end end end local
    W=128 local Y=S[6]if S[1]~=Y then W=W+1 end if S[2]~=Y then W=W+2 end if
    S[3]~=Y then W=W+4 end if S[4]~=Y then W=W+8 end if S[5]~=Y then W=W+16 end
    local P,V if#T>1 then P=T[Y+1].value V=T[2-Y].value else P=T[1].value
    V=T[1].value end return W,P,V end local function B(G,K,Q)return
    math.floor(G/(K^Q))end local J=0 local function X()for Z=0,15 do
    h[2^Z]=("%x"):format(Z)end for et=0,6^6 do local tt=B(et,6,0)%6 local
    at=B(et,6,1)%6 local ot=B(et,6,2)%6 local it=B(et,6,3)%6 local nt=B(et,6,4)%6
    local st=B(et,6,5)%6 local ht={}ht[st]=5 ht[nt]=4 ht[it]=3 ht[ot]=2 ht[at]=1
    ht[tt]=0 local rt=r(ht[tt],ht[at],ht[ot],ht[it],ht[nt],ht[st])if not i[rt]then
    J=J+1 local dt,lt,ut=w(tt,at,ot,it,nt,st)local ct=ht[lt]+1 local mt=ht[ut]+1
    n[rt]=ct s[rt]=mt i[rt]=string.char(dt)end end end
    e.internal.generate_lookups=X e.internal.calculate_texel=w
    e.internal.make_pattern_id=r e.internal.base_n_rshift=B function
    e.make_canvas_scanline(ft)return
    setmetatable({},{__newindex=function(wt,yt,pt)if type(yt)=="number"and yt%1~=0
    then error(("Tried to write a float pixel. x:%s y:%s"):format(yt,ft),2)else
    rawset(wt,yt,pt)end end})end function e.make_canvas(vt)local
    bt=e.make_canvas_scanline("NONE")local gt=getmetatable(bt)function
    gt.tostring()return"pixelbox_dummy_oob"end return setmetatable(vt
    or{},{__index=function(kt,qt)if type(qt)=="number"and qt%1~=0 then
    error(("Tried to write float scanline. y:%s"):format(qt),2)end return bt
    end})end function e.setup_canvas(jt,xt,zt,Et)for Tt=1,jt.height do local At if
    not rawget(xt,Tt)then At=e.make_canvas_scanline(Tt)rawset(xt,Tt,At)else
    At=xt[Tt]end for Ot=1,jt.width do if not(At[Ot]and Et)then At[Ot]=zt end end
    end return xt end function e.restore(It,Nt,St,Ht)if not St then local
    Rt=e.setup_canvas(It,e.make_canvas(),Nt)It.canvas=Rt It.CANVAS=Rt else
    e.setup_canvas(It,It.canvas,Nt,Ht)end end local Dt={}local
    Lt={0,0,0,0,0,0}function t:render()local Ut=self.term local
    Ct,Mt=Ut.blit,Ut.setCursorPos local Ft=self.canvas local Wt,Yt,Pt={},{},{}local
    Vt,Bt=self.x_offset,self.y_offset local Gt,Kt=self.width,self.height local Qt=0
    for Jt=1,Kt,3 do Qt=Qt+1 local Xt=Ft[Jt]local Zt=Ft[Jt+1]local ea=Ft[Jt+2]local
    ta=0 for aa=1,Gt,2 do local oa=aa+1 local
    ia,na,sa,ha,ra,da=Xt[aa],Xt[oa],Zt[aa],Zt[oa],ea[aa],ea[oa]local
    la,ua,ca=" ",1,ia local ma=na==ia and sa==ia and ha==ia and ra==ia and da==ia
    if not ma then Dt[da]=5 Dt[ra]=4 Dt[ha]=3 Dt[sa]=2 Dt[na]=1 Dt[ia]=0 local
    fa=Dt[na]+Dt[sa]*3+Dt[ha]*4+Dt[ra]*20+Dt[da]*100 local wa=n[fa]local
    ya=s[fa]Lt[1]=ia Lt[2]=na Lt[3]=sa Lt[4]=ha Lt[5]=ra Lt[6]=da
    ua=Lt[wa]ca=Lt[ya]la=i[fa]end ta=ta+1 Wt[ta]=la Yt[ta]=h[ua]Pt[ta]=h[ca]end
    Mt(1+Vt,Qt+Bt)Ct(a(Wt,""),a(Yt,""),a(Pt,""))end end function
    t:clear(pa)e.restore(self,h[pa or""]and pa or self.background,true,false)end
    function t:set_pixel(va,ba,ga)self.canvas[ba][va]=ga end function
    t:set_canvas(ka)self.canvas=ka self.CANVAS=ka end function
    t:resize(qa,ja,xa)self.term_width=math.floor(qa+0.5)self.term_height=math.floor(ja+0.5)self.width=math.floor(qa+0.5)*2
    self.height=math.floor(ja+0.5)*3 e.restore(self,xa or
    self.background,true,true)end function e.module_error(za,Ea,Ta,Aa)Ta=Ta or 1 if
    za.__contact and not Aa then local
    Oa,Ia=pcall(error,Ea,Ta+2)printError(Ia)error((za.__report_msg
    or"\nReport module issue at:\n-> __contact"):gsub("[%w_]+",za),0)elseif not Aa
    then error(Ea,Ta+1)end end function t:load_module(Na)for Sa,Ha in ipairs(Na
    or{})do local
    Ra={__author=Ha.author,__name=Ha.name,__contact=Ha.contact,__report_msg=Ha.report_msg}local
    Da,La=Ha.init(self,Ra,e,e.shared_data,e.initialized,Na)La=La or{}Ra.__fn=Da if
    self.modules[Ha.id]and not Na.force then
    e.module_error(Ra,("Module ID conflict: %q"):format(Ha.id),2,Na.supress)else
    self.modules[Ha.id]=Ra if La.verified_load then La.verified_load()end end for
    Ua in pairs(Da)do if self.modules.module_functions[Ua]and not Na.force then
    e.module_error(Ra,("Module %q tried to register already existing element: %q"):format(Ha.id,Ua),2,Na.supress)else
    self.modules.module_functions[Ua]={id=Ha.id,name=Ua}end end end end function
    e.new(Ca,Ma,Fa)local Wa={modules={module_functions={}}}Wa.background=Ma or
    Ca.getBackgroundColor()local Ya,Pa=Ca.getSize()Wa.term=Ca
    setmetatable(Wa,{__index=function(Va,Ba)local
    Ga=rawget(Wa.modules.module_functions,Ba)if Ga then return
    Wa.modules[Ga.id].__fn[Ga.name]end return
    rawget(t,Ba)end})Wa.__pixelbox_lite=true Wa.term_width=Ya Wa.term_height=Pa
    Wa.width=Ya*2 Wa.height=Pa*3 Wa.x_offset=0 Wa.y_offset=0
    e.restore(Wa,Wa.background)if type(Fa)=="table"then Wa:load_module(Fa)end if
    not e.initialized then X()e.initialized=true end return Wa end return e
end

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

-- Helper functions
local function isInBounds(x, y, bx, by, bw, bh)
    return x >= bx and x < bx + bw and y >= by and y < by + bh
end

local function drawFilledRect(box, x, y, w, h, col)
    for py = y, y + h - 1 do
        for px = x, x + w - 1 do
            if px >= 1 and px <= box.width and py >= 1 and py <= box.height then
                box:set_pixel(px, py, col)
            end
        end
    end
end

local function drawRect(box, x, y, w, h, col)
    for px = x, x + w - 1 do
        if px >= 1 and px <= box.width then
            if y >= 1 and y <= box.height then box:set_pixel(px, y, col) end
            if y + h - 1 >= 1 and y + h - 1 <= box.height then box:set_pixel(px, y + h - 1, col) end
        end
    end
    for py = y, y + h - 1 do
        if py >= 1 and py <= box.height then
            if x >= 1 and x <= box.width then box:set_pixel(x, py, col) end
            if x + w - 1 >= 1 and x + w - 1 <= box.width then box:set_pixel(x + w - 1, py, col) end
        end
    end
end

local function drawText(box, x, y, text, textCol, scale)
    scale = scale or 1
    local chars = {
        A={{1,1,1},{1,0,1},{1,1,1},{1,0,1},{1,0,1}},
        B={{1,1,0},{1,0,1},{1,1,0},{1,0,1},{1,1,0}},
        C={{0,1,1},{1,0,0},{1,0,0},{1,0,0},{0,1,1}},
        D={{1,1,0},{1,0,1},{1,0,1},{1,0,1},{1,1,0}},
        E={{1,1,1},{1,0,0},{1,1,0},{1,0,0},{1,1,1}},
        F={{1,1,1},{1,0,0},{1,1,0},{1,0,0},{1,0,0}},
        G={{0,1,1},{1,0,0},{1,0,1},{1,0,1},{0,1,1}},
        H={{1,0,1},{1,0,1},{1,1,1},{1,0,1},{1,0,1}},
        I={{1,1,1},{0,1,0},{0,1,0},{0,1,0},{1,1,1}},
        J={{0,0,1},{0,0,1},{0,0,1},{1,0,1},{0,1,0}},
        K={{1,0,1},{1,0,1},{1,1,0},{1,0,1},{1,0,1}},
        L={{1,0,0},{1,0,0},{1,0,0},{1,0,0},{1,1,1}},
        M={{1,0,1},{1,1,1},{1,0,1},{1,0,1},{1,0,1}},
        N={{1,0,1},{1,1,1},{1,0,1},{1,0,1},{1,0,1}},
        O={{0,1,0},{1,0,1},{1,0,1},{1,0,1},{0,1,0}},
        P={{1,1,0},{1,0,1},{1,1,0},{1,0,0},{1,0,0}},
        Q={{0,1,0},{1,0,1},{1,0,1},{1,1,0},{0,1,1}},
        R={{1,1,0},{1,0,1},{1,1,0},{1,0,1},{1,0,1}},
        S={{0,1,1},{1,0,0},{0,1,0},{0,0,1},{1,1,0}},
        T={{1,1,1},{0,1,0},{0,1,0},{0,1,0},{0,1,0}},
        U={{1,0,1},{1,0,1},{1,0,1},{1,0,1},{0,1,0}},
        V={{1,0,1},{1,0,1},{1,0,1},{1,0,1},{0,1,0}},
        W={{1,0,1},{1,0,1},{1,0,1},{1,1,1},{1,0,1}},
        X={{1,0,1},{1,0,1},{0,1,0},{1,0,1},{1,0,1}},
        Y={{1,0,1},{1,0,1},{0,1,0},{0,1,0},{0,1,0}},
        Z={{1,1,1},{0,0,1},{0,1,0},{1,0,0},{1,1,1}},
        [" "]={{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0}},
        ["0"]={{0,1,0},{1,0,1},{1,0,1},{1,0,1},{0,1,0}},
        ["1"]={{0,1,0},{1,1,0},{0,1,0},{0,1,0},{1,1,1}},
        ["2"]={{1,1,0},{0,0,1},{0,1,0},{1,0,0},{1,1,1}},
        ["3"]={{1,1,0},{0,0,1},{0,1,0},{0,0,1},{1,1,0}},
        ["4"]={{1,0,1},{1,0,1},{1,1,1},{0,0,1},{0,0,1}},
        ["5"]={{1,1,1},{1,0,0},{1,1,0},{0,0,1},{1,1,0}},
        ["6"]={{0,1,1},{1,0,0},{1,1,0},{1,0,1},{0,1,0}},
        ["7"]={{1,1,1},{0,0,1},{0,1,0},{1,0,0},{1,0,0}},
        ["8"]={{0,1,0},{1,0,1},{0,1,0},{1,0,1},{0,1,0}},
        ["9"]={{0,1,0},{1,0,1},{0,1,1},{0,0,1},{1,1,0}},
    }
    
    local cx = x
    for i = 1, #text do
        local c = text:sub(i,i):upper()
        local char = chars[c]
        if char then
            for row = 1, 5 do
                for col = 1, 3 do
                    if char[row][col] == 1 then
                        for sy = 0, scale - 1 do
                            for sx = 0, scale - 1 do
                                local px = cx + (col - 1) * scale + sx
                                local py = y + (row - 1) * scale + sy
                                if px >= 1 and px <= box.width and py >= 1 and py <= box.height then
                                    box:set_pixel(px, py, textCol)
                                end
                            end
                        end
                    end
                end
            end
        end
        cx = cx + 4 * scale
    end
    return cx - x
end

-- Button Component
function gui.Button(x, y, w, h, text, callback)
    local btn = {
        type = "button",
        x = x, y = y, w = w, h = h,
        text = text or "Button",
        callback = callback or function() end,
        enabled = true,
        hovered = false,
        pressed = false,
        bgColor = gui.colors.primary,
        textColor = gui.colors.text,
        hoverColor = gui.colors.secondary
    }
    
    function btn:render(box)
        local col = self.enabled and (self.hovered and self.hoverColor or self.bgColor) or gui.colors.disabled
        drawFilledRect(box, self.x, self.y, self.w, self.h, col)
        drawRect(box, self.x, self.y, self.w, self.h, gui.colors.border)
        
        local textW = #self.text * 4
        local tx = self.x + math.floor((self.w - textW) / 2)
        local ty = self.y + math.floor(self.h / 2) - 2
        drawText(box, tx, ty, self.text, self.textColor)
    end
    
    function btn:handleClick(mx, my, button)
        if not self.enabled then return false end
        if button == 1 and isInBounds(mx, my, self.x, self.y, self.w, self.h) then
            self.pressed = true
            self:callback()
            return true
        end
        return false
    end
    
    function btn:handleMouse(mx, my)
        self.hovered = isInBounds(mx, my, self.x, self.y, self.w, self.h) and self.enabled
    end
    
    return btn
end

-- Panel Component
function gui.Panel(x, y, w, h, color)
    local panel = {
        type = "panel",
        x = x, y = y, w = w, h = h,
        bgColor = color or gui.colors.background,
        borderColor = gui.colors.border,
        children = {}
    }
    
    function panel:render(box)
        drawFilledRect(box, self.x, self.y, self.w, self.h, self.bgColor)
        drawRect(box, self.x, self.y, self.w, self.h, self.borderColor)
        
        for _, child in ipairs(self.children) do
            child:render(box)
        end
    end
    
    function panel:add(component)
        table.insert(self.children, component)
    end
    
    function panel:handleClick(mx, my, button)
        for i = #self.children, 1, -1 do
            if self.children[i].handleClick and self.children[i]:handleClick(mx, my, button) then
                return true
            end
        end
        return false
    end
    
    function panel:handleMouse(mx, my)
        for _, child in ipairs(self.children) do
            if child.handleMouse then
                child:handleMouse(mx, my)
            end
        end
    end
    
    return panel
end

-- Label Component
function gui.Label(x, y, text, color)
    local label = {
        type = "label",
        x = x, y = y,
        text = text or "",
        textColor = color or gui.colors.text,
        scale = 1
    }
    
    function label:render(box)
        drawText(box, self.x, self.y, self.text, self.textColor, self.scale)
    end
    
    function label:setText(text)
        self.text = text
    end
    
    return label
end

-- Checkbox Component
function gui.Checkbox(x, y, label, checked, callback)
    local cb = {
        type = "checkbox",
        x = x, y = y,
        label = label or "",
        checked = checked or false,
        callback = callback or function() end,
        enabled = true,
        size = 8
    }
    
    function cb:render(box)
        local col = self.enabled and gui.colors.border or gui.colors.disabled
        drawRect(box, self.x, self.y, self.size, self.size, col)
        
        if self.checked then
            drawFilledRect(box, self.x + 2, self.y + 2, self.size - 4, self.size - 4, gui.colors.success)
        end
        
        if self.label ~= "" then
            drawText(box, self.x + self.size + 4, self.y + 1, self.label, gui.colors.text)
        end
    end
    
    function cb:handleClick(mx, my, button)
        if not self.enabled then return false end
        if button == 1 and isInBounds(mx, my, self.x, self.y, self.size, self.size) then
            self.checked = not self.checked
            self:callback(self.checked)
            return true
        end
        return false
    end
    
    return cb
end

-- Slider Component
function gui.Slider(x, y, w, min, max, value, callback)
    local slider = {
        type = "slider",
        x = x, y = y, w = w, h = 6,
        min = min or 0,
        max = max or 100,
        value = value or min or 0,
        callback = callback or function() end,
        enabled = true,
        dragging = false
    }
    
    function slider:render(box)
        local trackY = self.y + 2
        drawFilledRect(box, self.x, trackY, self.w, 2, gui.colors.border)
        
        local percent = (self.value - self.min) / (self.max - self.min)
        local handleX = self.x + math.floor(percent * (self.w - 4))
        
        local handleCol = self.enabled and gui.colors.primary or gui.colors.disabled
        drawFilledRect(box, handleX, self.y, 4, self.h, handleCol)
    end
    
    function slider:handleClick(mx, my, button)
        if not self.enabled then return false end
        if button == 1 and isInBounds(mx, my, self.x, self.y, self.w, self.h) then
            self.dragging = true
            self:updateValue(mx)
            return true
        end
        return false
    end
    
    function slider:handleDrag(mx, my)
        if self.dragging then
            self:updateValue(mx)
        end
    end
    
    function slider:handleRelease()
        self.dragging = false
    end
    
    function slider:updateValue(mx)
        local percent = math.max(0, math.min(1, (mx - self.x) / self.w))
        self.value = self.min + percent * (self.max - self.min)
        self:callback(self.value)
    end
    
    return slider
end

-- GUI Manager
function gui.new(term_obj)
    local box = gui.pixelbox.new(term_obj or term.current())
    
    local manager = {
        box = box,
        components = {},
        mouseDown = false
    }
    
    function manager:add(component)
        table.insert(self.components, component)
        return component
    end
    
    function manager:render()
        self.box:clear()
        for _, comp in ipairs(self.components) do
            comp:render(self.box)
        end
        self.box:render()
    end
    
    function manager:handleEvent(event)
        if event[1] == "mouse_click" then
            local mx, my = (event[3] - 1) * 2 + 1, (event[4] - 1) * 3 + 1
            local button = event[2]
            
            for i = #self.components, 1, -1 do
                local comp = self.components[i]
                if comp.handleClick and comp:handleClick(mx, my, button) then
                    self.mouseDown = true
                    break
                end
            end
            self:render()
            
        elseif event[1] == "mouse_drag" then
            local mx, my = (event[3] - 1) * 2 + 1, (event[4] - 1) * 3 + 1
            
            for _, comp in ipairs(self.components) do
                if comp.handleDrag then
                    comp:handleDrag(mx, my)
                end
                if comp.handleMouse then
                    comp:handleMouse(mx, my)
                end
            end
            self:render()
            
        elseif event[1] == "mouse_up" then
            for _, comp in ipairs(self.components) do
                if comp.handleRelease then
                    comp:handleRelease()
                end
            end
            self.mouseDown = false
            self:render()
            
        elseif event[1] == "term_resize" then
            local w, h = self.box.term.getSize()
            self.box:resize(w, h)
            self:render()
        end
    end
    
    function manager:run()
        self:render()
        while true do
            local event = {os.pullEvent()}
            self:handleEvent(event)
        end
    end
    
    return manager
end

return gui
