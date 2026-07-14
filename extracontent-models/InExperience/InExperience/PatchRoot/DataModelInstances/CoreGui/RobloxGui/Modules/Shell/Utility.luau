local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

game:GetService("CoreGui")

local LocalizationService = game:GetService("LocalizationService")
local PlatformService = nil

pcall(function() -- line: 10
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local t1 = {
	IsFinite = function(p1) -- line: 15
		return p1 == p1 and (p1 ~= 1e999 and p1 ~= -1e999)
	end
}

function t1.FindAncestorOfType(p2, p3) -- line: 19
	-- upvalues: t1 (copy)
	local v20 = p2 and p2.Parent

	if v20 then
		if v20:IsA(p3) then
			return v20
		end

		return t1.FindAncestorOfType(v20, p3)
	end

	return nil
end
function t1.CalculateRelativeDimensions(p4, p5, p6, _) -- line: 31
	-- upvalues: GuiService (copy), t1 (copy)
	local ScreenResolution = GuiService:GetScreenResolution()
	local v26 = t1.FindAncestorOfType(p4, "SurfaceGui")

	if v26 then
		ScreenResolution = v26.CanvasSize
	end

	local v27 = p5 / p6

	if p6.y > 0 and ScreenResolution.y > 0 then
		v27 *= p6.x / p6.y / (ScreenResolution.x / ScreenResolution.y)

		local p4Parent = p4.Parent

		if p4Parent then
			local v29 = 1 / (p4Parent.AbsoluteSize / ScreenResolution)

			if t1.IsFinite(v29.x) and t1.IsFinite(v29.y) then
				return UDim2.new(v29.x * v27.x, 0, v29.y * v27.y, 0)
			end
		end
	end

	return UDim2.new(v27.x, 0, v27.y, 0)
end

t1.Enum = {
	Anchor = {
		TopLeft = 1,
		TopMiddle = 2,
		TopRight = 3,
		CenterLeft = 4,
		Center = 5,
		CenterRight = 6,
		BottomLeft = 7,
		BottomMiddle = 8,
		BottomRight = 9
	}
}

function t1.CalculateFit(p8, p9) -- line: 76
	local v32 = p8.AbsoluteSize / p9
	local v33 = p9 * math.min(v32.X, v32.Y)

	return UDim2.new(0, v33.X, 0, v33.Y)
end
function t1.CalculateFill(p10, p11) -- line: 84
	local v36 = p10.AbsoluteSize / p11
	local v37 = p11 * math.max(v36.X, v36.Y)

	return UDim2.new(0, v37.X, 0, v37.Y)
end

local t2 = {}

local function getActiveTween(p12, p13) -- line: 95
	-- upvalues: t2 (copy)
	return t2[p12] and t2[p12][p13]
end
local function setActiveTween(p14, p15, p16) -- line: 99
	-- upvalues: t2 (copy)
	if not t2[p14] then
		t2[p14] = {}
	end

	t2[p14][p15] = p16
end

function t1.Linear(p17, p18, p19, p20) -- line: 106
	if p20 <= p17 then
		return p18 + p19
	end

	return p19 * p17 / p20 + p18
end
function t1.EaseOutQuad(p21, p22, p23, p24) -- line: 112
	if p24 <= p21 then
		return p22 + p23
	end

	local v51 = p21 / p24

	return -p23 * v51 * (v51 - 2) + p22
end
function t1.EaseInOutQuad(p25, p26, p27, p28) -- line: 119
	if p28 <= p25 then
		return p26 + p27
	end

	local v56 = p25 / (p28 / 2)

	if v56 < 1 then
		return p27 / 2 * v56 * v56 + p26
	end

	local v57 = v56 - 1

	return -p27 / 2 * (v57 * (v57 - 2) - 1) + p26
end
function t1.SCurveUDim2(p29, p30, p31, p32) -- line: 128
	if p32 <= p29 then
		return p30 + p31
	end

	local v62 = p29 / p32

	if v62 < 0 then
		v62 = 0
	end

	if v62 > 1 then
		v62 = 1
	end

	local v63 = 3 * v62 * v62 - 2 * v62 * v62 * v62

	return UDim2.new(v63 * p31.X.Scale, v63 * p31.X.Offset, v63 * p31.Y.Scale, v63 * p31.Y.Offset) + p30
end
function t1.SCurveVector2(p33, p34, p35, p36) -- line: 141
	if p36 <= p33 then
		return p34 + p35
	end

	local v68 = p33 / p36

	if v68 < 0 then
		v68 = 0
	end

	if v68 > 1 then
		v68 = 1
	end

	local v69 = 3 * v68 * v68 - 2 * v68 * v68 * v68

	return Vector2.new(v69 * p35.X, v69 * p35.Y) + p34
end
function t1.PropertyTweener(p37, p38, p39, p40, p41, p42, p43, p44) -- line: 152
	-- upvalues: t1 (copy), t2 (copy), RunService (copy)
	local u78 = p42 or t1.Linear
	local v79 = p43 or false
	local t3 = {
		StartTime = tick()
	}

	t3.EndTime = t3.StartTime + p41
	t3.Cancelled = false

	local u81 = false
	local n1 = 0

	local function setValue(p45) -- line: 165
		-- upvalues: p37 (copy), p38 (copy)
		if p37 then
			p37[p38] = p45
		end
	end
	local function finalize() -- line: 171
		-- upvalues: u78 (ref), p39 (copy), p40 (copy), p37 (copy), p38 (copy), u81 (ref), n1 (ref), t2 (copy), t3 (copy), p44 (copy)
		local v207 = u78(1, p39, p40 - p39, 1)

		if p37 then
			p37[p38] = v207
		end

		u81 = true
		n1 = 1

		local v208 = p38
		local v209 = p37

		if (t2[v208] and t2[v208][v209]) == t3 then
			local v210 = p38
			local v211 = p37

			if not t2[v210] then
				t2[v210] = {}
			end

			t2[v210][v211] = nil
		end

		if p44 then
			p44()
		end
	end

	if v79 or (not t2[p38] or not t2[p38][p37]) then
		if t2[p38] and t2[p38][p37] then
			(t2[p38] and t2[p38][p37]):Cancel()
		end

		if not t2[p38] then
			t2[p38] = {}
		end

		t2[p38][p37] = t3

		local v85 = u78(0, p39, p40 - p39, p41)

		if p37 then
			p37[p38] = v85
		end

		spawn(function() -- line: 193
			-- upvalues: t3 (copy), p37 (copy), u78 (ref), p39 (copy), p40 (copy), p41 (copy), p38 (copy), n1 (ref), t1 (copy), RunService (copy), finalize (copy), t2 (copy)
			local timestamp = tick()

			while timestamp < t3.EndTime and p37 and not t3.Cancelled do
				local v213 = u78(timestamp - t3.StartTime, p39, p40 - p39, p41)

				if p37 then
					p37[p38] = v213
				end

				n1 = t1.Clamp(0, 1, (timestamp - t3.StartTime) / p41)
				RunService.RenderStepped:wait()
				timestamp = tick()
			end

			if t3.Cancelled == false and p37 then
				finalize()
			end

			local v214 = p38
			local v215 = p37

			if (t2[v214] and t2[v214][v215]) == t3 then
				local v216 = p38
				local v217 = p37

				if not t2[v216] then
					t2[v216] = {}
				end

				t2[v216][v217] = nil
			end
		end)
	else
		u81 = true
	end

	function t3.GetFinal(_) -- line: 213
		-- upvalues: p40 (copy)
		return p40
	end
	function t3.GetPercentComplete(_) -- line: 217
		-- upvalues: n1 (ref)
		return n1
	end
	function t3.IsFinished(_) -- line: 221
		-- upvalues: u81 (ref)
		return u81
	end
	function t3.Finish(p49) -- line: 225
		-- upvalues: u81 (ref), finalize (copy)
		if not u81 then
			p49:Cancel()
			finalize()
		end
	end
	function t3.Cancel(_) -- line: 232
		-- upvalues: t3 (copy), u81 (ref), p38 (copy), p37 (copy), t2 (copy)
		t3.Cancelled = true
		u81 = true

		local v223 = p38
		local v224 = p37

		if (t2[v223] and t2[v223][v224]) == t3 then
			local v225 = p38
			local v226 = p37

			if not t2[v225] then
				t2[v225] = {}
			end

			t2[v225][v226] = nil
		end
	end

	return t3
end
function t1.CancelTweens(p51) -- line: 243
	for k, v in pairs(p51) do
		v:Finish()
		p51[k] = nil
	end
end
function t1.Signal() -- line: 252
	local t4 = {}
	local BindableEvent = Instance.new("BindableEvent")
	local t5 = nil
	local u92 = nil

	function t4.fire(_, ...) -- line: 260
		-- upvalues: t5 (ref), u92 (ref), BindableEvent (copy)
		t5 = { ... }
		u92 = select("#", ...)
		BindableEvent:Fire()
	end
	function t4.connect(_, p54) -- line: 266
		-- upvalues: BindableEvent (copy), t5 (ref), u92 (ref)
		if not p54 then
			error("connect(nil)", 2)
		end

		return BindableEvent.Event:connect(function() -- line: 268
			-- upvalues: p54 (copy), t5 (ref), u92 (ref)
			p54(unpack(t5, 1, u92))
		end)
	end
	function t4.wait(_) -- line: 273
		-- upvalues: BindableEvent (copy), t5 (ref), u92 (ref)
		BindableEvent.Event:wait()
		assert(t5, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")

		return unpack(t5, 1, u92)
	end

	return t4
end
function t1.DisconnectEvent(p56) -- line: 282
	if p56 then
		p56:disconnect()
	end

	return nil
end
function t1.DisconnectEvents(p57) -- line: 289
	if p57 and type(p57) == "table" then
		for _, v in pairs(p57) do
			v:disconnect()
		end
	end
end
function t1.Clamp(p58, p59, p60) -- line: 299
	return (math.max(p58, (math.min(p59, p60))))
end
function t1.ClampVector2(p61, p62, p63) -- line: 303
	-- upvalues: t1 (copy)
	return Vector2.new(t1.Clamp(p61.x, p62.x, p63.x), t1.Clamp(p61.y, p62.y, p63.y))
end
function t1.TweenPositionOrSet(p64, ...) -- line: 307
	if p64:IsDescendantOf(game) then
		p64:TweenPositionInternal(...)

		return
	end

	p64.Position = select(1, ...)
end
function t1.ClampCanvasPosition(p65, p66) -- line: 316
	-- upvalues: t1 (copy)
	local v106 = p65.Parent and p65.Parent.AbsoluteSize or Vector2.new(0, 0)
	local vector2 = Vector2.new(p65.CanvasSize.X.Scale * v106.X + p65.CanvasSize.X.Offset, p65.CanvasSize.Y.Scale * v106.Y + p65.CanvasSize.Y.Offset)
	local v108 = t1.Clamp(0, vector2.X - p65.AbsoluteWindowSize.X, p66.X)
	local v109 = t1.Clamp(0, vector2.Y - p65.AbsoluteWindowSize.Y, p66.Y)

	return Vector2.new(v108, v109)
end
function t1.Round(p67, p68) -- line: 327
	local v112 = p68 or 1

	return math.floor((p67 + v112 / 2) / v112) * v112
end
function t1.ChompString(p69) -- line: 335
	return tostring(p69):gsub("^%s+", ""):gsub("%s+$", "")
end
function t1.SpaceNormalizeString(p70) -- line: 340
	return tostring(p70):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function getDelimiterByLocale() -- line: 344
	-- upvalues: LocalizationService (copy)
	local v115 = LocalizationService.RobloxLocaleId:lower()
	local t6 = {
		["en-us"] = ",",
		["zh-hk"] = "",
		["zh-tw"] = "",
		["nb-no"] = "\194\160",
		["es-es"] = " ",
		["nl-nl"] = ".",
		["it-it"] = ".",
		["tr-tr"] = ".",
		["ru-ru"] = " ",
		["fi-fi"] = "\194\160",
		["da-dk"] = ".",
		["de-de"] = ".",
		["fr-fr"] = "\194\160",
		["pt-br"] = ".",
		["pt-pt"] = ".",
		["pl-pl"] = " ",
		["sv-se"] = " "
	}

	if t6[v115] then
		return t6[v115]
	end

	return ","
end

function t1.FormatNumberString(p71) -- line: 375
	-- upvalues: getDelimiterByLocale (copy), t1 (copy)
	local v118 = getDelimiterByLocale()
	local v119 = t1.ChompString(p71)
	local v120 = string.format("%%1%s%%2", v118)

	repeat
		local count

		v119, count = string.gsub(v119, "^(-?%d+)(%d%d%d)", v120)
	until count == 0

	return v119
end
function t1.PrettyPrint(p72) -- line: 391
	-- upvalues: t1 (copy)
	if type(p72) == "table" then
		local s1 = "{"

		for k, v in pairs(p72) do
			local v126 = s1 == "{" and s1 or s1 .. ", "

			if type(k) == "string" then
				v126 ..= k .. " = "
			elseif type(k) ~= "number" then
				v126 ..= "[" .. k .. "] = "
			end

			s1 = v126 .. t1.PrettyPrint(v)
		end

		return s1 .. "}"
	end

	if type(p72) == "string" then
		return "'" .. p72 .. "'"
	end

	return (tostring(p72))
end

local function SCurveTranform(p73, p74, p75) -- line: 415
	-- upvalues: t1 (copy)
	local v130 = p74 or 0.35
	local v131 = p75 or 0.8
	local v132 = t1.Clamp(-1, 1, p73)

	if v132 >= 0 then
		return v130 * v132 / (v130 - v132 + 1)
	end

	return -(v131 * -v132 / (v131 + v132 + 1))
end
local function toSCurveSpace(p76, p77) -- line: 425
	local v135 = p77 or 0.1

	return (1 + v135) * (math.abs(p76) * 2 - 1) - v135
end
local function fromSCurveSpace(p78) -- line: 430
	return p78 / 2 + 0.5
end

function t1.GamepadLinearToCurve(p79, p80, _, _) -- line: 434
	-- upvalues: t1 (copy)
	local function onAxis(p83) -- line: 435
		-- upvalues: p80 (copy), t1 (copy)
		local v232 = not (p83 < 0) and 1 or -1
		local v233 = math.abs(p83)
		local v234 = p80 or 0.1
		local v235 = (1 + v234) * (math.abs(v233) * 2 - 1) - v234
		local v236 = nil or 0.35
		local v237 = nil or 0.8
		local v238 = t1.Clamp(-1, 1, v235)
		local v239 = ((if not (v238 >= 0) then -(v237 * -v238 / (v237 + v238 + 1)) else v236 * v238 / (v236 - v238 + 1))) / 2 + 0.5

		return t1.Clamp(-1, 1, v239 * v232)
	end

	local new = Vector2.new
	local x = p79.x
	local v144 = not (x < 0) and 1 or -1
	local v145 = math.abs(x)
	local v146 = p80 or 0.1
	local v147 = (1 + v146) * (math.abs(v145) * 2 - 1) - v146
	local v148 = nil or 0.35
	local v149 = nil or 0.8
	local v150 = t1.Clamp(-1, 1, v147)
	local v151 = ((if not (v150 >= 0) then -(v149 * -v150 / (v149 + v150 + 1)) else v148 * v150 / (v148 - v150 + 1))) / 2 + 0.5

	return new(t1.Clamp(-1, 1, v151 * v144), onAxis(p79.y))
end
function t1.IsFastFlagEnabled(p84) -- line: 444
	local ok, result = pcall(function() -- line: 445
		-- upvalues: p84 (copy)
		return settings():GetFFlag(p84)
	end)

	return ok and result
end
function t1.GetFastVariable(p85) -- line: 452
	local ok, result = pcall(function() -- line: 453
		-- upvalues: p85 (copy)
		return settings():GetFVariable(p85)
	end)

	return ok and result
end

local function getLocalPlayer() -- line: 460
	-- upvalues: Players (copy)
	while Players.LocalPlayer == nil do
		wait()
	end

	return Players.LocalPlayer
end

function t1.IsFeatureNonZero(p86) -- line: 467
	-- upvalues: t1 (copy)
	return (tonumber(t1.GetFastVariable(p86)) or 0) ~= 0
end
function t1.IsFeatureRolledOut(p87) -- line: 471
	-- upvalues: Players (copy), t1 (copy)
	while Players.LocalPlayer == nil do
		wait()
	end

	return Players.LocalPlayer.UserId % 100 < (tonumber(t1.GetFastVariable(p87)) or 0)
end
function t1.ExponentialRepeat(p88, p89, p90) -- line: 476
	local v163 = p90 or 6
	local n2 = 1

	while n2 <= v163 and p88() do
		if p89() then
			return
		end

		wait(n2 ^ 2)
		n2 += 1
	end
end
function t1.SplitString(p91, p92) -- line: 490
	local t7 = {}

	if p91 and p92 then
		for match in string.gmatch(p91, "([^" .. p92 .. "]+)") do
			table.insert(t7, match)
		end
	end

	return t7
end

local function findAssetsHelper(p93, p94, p95) -- line: 501
	-- upvalues: findAssetsHelper (copy)
	if not p93 then
		return
	end

	if p93:IsA("CharacterMesh") then
		if p93.MeshId > 0 then
			table.insert(p94, p95 .. tostring(p93.MeshId))
		end

		if p93.BaseTextureId > 0 then
			table.insert(p94, p95 .. tostring(p93.BaseTextureId))
		end

		if p93.OverlayTextureId > 0 then
			table.insert(p94, p95 .. tostring(p93.OverlayTextureId))
		end
	elseif p93:IsA("FileMesh") then
		table.insert(p94, p93.MeshId)
		table.insert(p94, p93.TextureId)
	elseif p93:IsA("Decal") then
		table.insert(p94, p93.Texture)
	elseif p93:IsA("Pants") then
		table.insert(p94, p93.PantsTemplate)
	elseif p93:IsA("Shirt") then
		table.insert(p94, p93.ShirtTemplate)
	end

	for _, child in pairs(p93:GetChildren()) do
		findAssetsHelper(child, p94, p95)
	end
end

function t1.FindAssetsInModel(p96, p97) -- line: 529
	-- upvalues: findAssetsHelper (copy)
	local v176 = p97 or "https://assetgame.roblox.com/asset/?id="
	local t8 = {}

	findAssetsHelper(p96, t8, v176)

	return t8
end
function t1.ConvertFontSizeEnumToInt(p98) -- line: 536
	local p98Name = p98.Name

	return string.match(p98Name, "%d+") or 10
end
function t1.Upper(p99) -- line: 543
	-- upvalues: PlatformService (ref)
	if PlatformService then
		return PlatformService:Upper(p99)
	end

	return string.upper(p99)
end
function t1.SetSelectedCoreObject(p100) -- line: 551
	-- upvalues: GuiService (copy)
	GuiService.SelectedCoreObject = p100
end
function t1.AddSelectionParent(p101, p102) -- line: 555
	-- upvalues: GuiService (copy)
	GuiService:AddSelectionParent(p101, p102)
end
function t1.RemoveSelectionGroup(p103) -- line: 559
	-- upvalues: GuiService (copy)
	GuiService:RemoveSelectionGroup(p103)
end
function t1.GetTextBounds(p104) -- line: 563
	-- upvalues: TextService (copy)
	local v186 = false
	local TextSize = nil

	if p104 then
		if p104.TextFits then
			return true, p104.TextBounds
		end

		if not p104.TextWrapped then
			TextSize = TextService:GetTextSize(p104.Text, p104.TextSize, p104.Font, Vector2.new(0, 0))
			v186 = true
		end
	end

	return v186, TextSize
end
function t1.ResizeButtonWithText(p105, p106, p107, p108) -- line: 589
	-- upvalues: t1 (copy)
	local v192 = false
	local v193, v194 = t1.GetTextBounds(p106)

	if v193 and (p105.Size.X.Scale == 0 and p105.Size.Y.Scale == 0) then
		local vector2 = Vector2.new(p105.Size.X.Offset, p105.Size.Y.Offset)
		local vector2X = vector2.X
		local vector2Y = vector2.Y

		if p107 and vector2.X < v194.X + p107 * 2 then
			vector2X = v194.X + p107 * 2
			v192 = true
		end

		if p108 and vector2.Y < v194.Y + p108 * 2 then
			vector2Y = v194.Y + p108 * 2
			v192 = true
		end

		if v192 then
			p105.Size = UDim2.new(0, vector2X, 0, vector2Y)
		end
	end

	return v192
end
function t1.ResizeButtonWithDynamicText(p109, p110, p111, p112, p113) -- line: 616
	-- upvalues: t1 (copy)
	local v203 = t1.ResizeButtonWithText(p109, p110, p112, p113) or false
	local p110Text = p110.Text

	if p111 and #p111 > 0 then
		for i = 1, #p111 do
			p110.Text = p111[i]
			v203 = t1.ResizeButtonWithText(p109, p110, p112, p113) or v203
		end
	end

	p110.Text = p110Text

	return v203
end

return t1
