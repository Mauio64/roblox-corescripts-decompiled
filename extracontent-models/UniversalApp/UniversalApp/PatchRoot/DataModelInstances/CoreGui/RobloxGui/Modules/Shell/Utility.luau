local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

game:GetService("CoreGui")

local LocalizationService = game:GetService("LocalizationService")
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
local PlatformService = nil

pcall(function() -- line: 12
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local t1 = {
	IsFinite = function(p1) -- line: 17
		return p1 == p1 and (p1 ~= 1e999 and p1 ~= -1e999)
	end
}

function t1.FindAncestorOfType(p2, p3) -- line: 21
	-- upvalues: t1 (copy)
	local v21 = p2 and p2.Parent

	if v21 then
		if v21:IsA(p3) then
			return v21
		end

		return t1.FindAncestorOfType(v21, p3)
	end

	return nil
end
function t1.CalculateRelativeDimensions(p4, p5, p6, _) -- line: 33
	-- upvalues: GuiService (copy), t1 (copy)
	local ScreenResolution = GuiService:GetScreenResolution()
	local v27 = t1.FindAncestorOfType(p4, "SurfaceGui")

	if v27 then
		ScreenResolution = v27.CanvasSize
	end

	local v28 = p5 / p6

	if p6.y > 0 and ScreenResolution.y > 0 then
		v28 *= p6.x / p6.y / (ScreenResolution.x / ScreenResolution.y)

		local p4Parent = p4.Parent

		if p4Parent then
			local v30 = 1 / (p4Parent.AbsoluteSize / ScreenResolution)

			if t1.IsFinite(v30.x) and t1.IsFinite(v30.y) then
				return UDim2.new(v30.x * v28.x, 0, v30.y * v28.y, 0)
			end
		end
	end

	return UDim2.new(v28.x, 0, v28.y, 0)
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

function t1.CalculateFit(p8, p9) -- line: 78
	local v33 = p8.AbsoluteSize / p9
	local v34 = p9 * math.min(v33.X, v33.Y)

	return UDim2.new(0, v34.X, 0, v34.Y)
end
function t1.CalculateFill(p10, p11) -- line: 86
	local v37 = p10.AbsoluteSize / p11
	local v38 = p11 * math.max(v37.X, v37.Y)

	return UDim2.new(0, v38.X, 0, v38.Y)
end

local t2 = {}

local function getActiveTween(p12, p13) -- line: 97
	-- upvalues: t2 (copy)
	return t2[p12] and t2[p12][p13]
end
local function setActiveTween(p14, p15, p16) -- line: 101
	-- upvalues: t2 (copy)
	if not t2[p14] then
		t2[p14] = {}
	end

	t2[p14][p15] = p16
end

function t1.Linear(p17, p18, p19, p20) -- line: 108
	if p20 <= p17 then
		return p18 + p19
	end

	return p19 * p17 / p20 + p18
end
function t1.EaseOutQuad(p21, p22, p23, p24) -- line: 114
	if p24 <= p21 then
		return p22 + p23
	end

	local v52 = p21 / p24

	return -p23 * v52 * (v52 - 2) + p22
end
function t1.EaseInOutQuad(p25, p26, p27, p28) -- line: 121
	if p28 <= p25 then
		return p26 + p27
	end

	local v57 = p25 / (p28 / 2)

	if v57 < 1 then
		return p27 / 2 * v57 * v57 + p26
	end

	local v58 = v57 - 1

	return -p27 / 2 * (v58 * (v58 - 2) - 1) + p26
end
function t1.SCurveUDim2(p29, p30, p31, p32) -- line: 130
	if p32 <= p29 then
		return p30 + p31
	end

	local v63 = p29 / p32

	if v63 < 0 then
		v63 = 0
	end

	if v63 > 1 then
		v63 = 1
	end

	local v64 = 3 * v63 * v63 - 2 * v63 * v63 * v63

	return UDim2.new(v64 * p31.X.Scale, v64 * p31.X.Offset, v64 * p31.Y.Scale, v64 * p31.Y.Offset) + p30
end
function t1.SCurveVector2(p33, p34, p35, p36) -- line: 143
	if p36 <= p33 then
		return p34 + p35
	end

	local v69 = p33 / p36

	if v69 < 0 then
		v69 = 0
	end

	if v69 > 1 then
		v69 = 1
	end

	local v70 = 3 * v69 * v69 - 2 * v69 * v69 * v69

	return Vector2.new(v70 * p35.X, v70 * p35.Y) + p34
end
function t1.PropertyTweener(p37, p38, p39, p40, p41, p42, p43, p44) -- line: 154
	-- upvalues: t1 (copy), t2 (copy), RunService (copy)
	local u79 = p42 or t1.Linear
	local v80 = p43 or false
	local t3 = {
		StartTime = tick()
	}

	t3.EndTime = t3.StartTime + p41
	t3.Cancelled = false

	local u82 = false
	local n1 = 0

	local function setValue(p45) -- line: 167
		-- upvalues: p37 (copy), p38 (copy)
		if p37 then
			p37[p38] = p45
		end
	end
	local function finalize() -- line: 173
		-- upvalues: u79 (ref), p39 (copy), p40 (copy), p37 (copy), p38 (copy), u82 (ref), n1 (ref), t2 (copy), t3 (copy), p44 (copy)
		local v208 = u79(1, p39, p40 - p39, 1)

		if p37 then
			p37[p38] = v208
		end

		u82 = true
		n1 = 1

		local v209 = p38
		local v210 = p37

		if (t2[v209] and t2[v209][v210]) == t3 then
			local v211 = p38
			local v212 = p37

			if not t2[v211] then
				t2[v211] = {}
			end

			t2[v211][v212] = nil
		end

		if p44 then
			p44()
		end
	end

	if v80 or (not t2[p38] or not t2[p38][p37]) then
		if t2[p38] and t2[p38][p37] then
			(t2[p38] and t2[p38][p37]):Cancel()
		end

		if not t2[p38] then
			t2[p38] = {}
		end

		t2[p38][p37] = t3

		local v86 = u79(0, p39, p40 - p39, p41)

		if p37 then
			p37[p38] = v86
		end

		spawn(function() -- line: 195
			-- upvalues: t3 (copy), p37 (copy), u79 (ref), p39 (copy), p40 (copy), p41 (copy), p38 (copy), n1 (ref), t1 (copy), RunService (copy), finalize (copy), t2 (copy)
			local timestamp = tick()

			while timestamp < t3.EndTime and p37 and not t3.Cancelled do
				local v214 = u79(timestamp - t3.StartTime, p39, p40 - p39, p41)

				if p37 then
					p37[p38] = v214
				end

				n1 = t1.Clamp(0, 1, (timestamp - t3.StartTime) / p41)
				RunService.RenderStepped:wait()
				timestamp = tick()
			end

			if t3.Cancelled == false and p37 then
				finalize()
			end

			local v215 = p38
			local v216 = p37

			if (t2[v215] and t2[v215][v216]) == t3 then
				local v217 = p38
				local v218 = p37

				if not t2[v217] then
					t2[v217] = {}
				end

				t2[v217][v218] = nil
			end
		end)
	else
		u82 = true
	end

	function t3.GetFinal(_) -- line: 215
		-- upvalues: p40 (copy)
		return p40
	end
	function t3.GetPercentComplete(_) -- line: 219
		-- upvalues: n1 (ref)
		return n1
	end
	function t3.IsFinished(_) -- line: 223
		-- upvalues: u82 (ref)
		return u82
	end
	function t3.Finish(p49) -- line: 227
		-- upvalues: u82 (ref), finalize (copy)
		if not u82 then
			p49:Cancel()
			finalize()
		end
	end
	function t3.Cancel(_) -- line: 234
		-- upvalues: t3 (copy), u82 (ref), p38 (copy), p37 (copy), t2 (copy)
		t3.Cancelled = true
		u82 = true

		local v224 = p38
		local v225 = p37

		if (t2[v224] and t2[v224][v225]) == t3 then
			local v226 = p38
			local v227 = p37

			if not t2[v226] then
				t2[v226] = {}
			end

			t2[v226][v227] = nil
		end
	end

	return t3
end
function t1.CancelTweens(p51) -- line: 245
	for k, v in pairs(p51) do
		v:Finish()
		p51[k] = nil
	end
end
function t1.Signal() -- line: 254
	local t4 = {}
	local BindableEvent = Instance.new("BindableEvent")
	local t5 = nil
	local u93 = nil

	function t4.fire(_, ...) -- line: 262
		-- upvalues: t5 (ref), u93 (ref), BindableEvent (copy)
		t5 = { ... }
		u93 = select("#", ...)
		BindableEvent:Fire()
	end
	function t4.connect(_, p54) -- line: 268
		-- upvalues: BindableEvent (copy), t5 (ref), u93 (ref)
		if not p54 then
			error("connect(nil)", 2)
		end

		return BindableEvent.Event:connect(function() -- line: 270
			-- upvalues: p54 (copy), t5 (ref), u93 (ref)
			p54(unpack(t5, 1, u93))
		end)
	end
	function t4.wait(_) -- line: 275
		-- upvalues: BindableEvent (copy), t5 (ref), u93 (ref)
		BindableEvent.Event:wait()
		assert(t5, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")

		return unpack(t5, 1, u93)
	end

	return t4
end
function t1.DisconnectEvent(p56) -- line: 284
	if p56 then
		p56:disconnect()
	end

	return nil
end
function t1.DisconnectEvents(p57) -- line: 291
	if p57 and type(p57) == "table" then
		for _, v in pairs(p57) do
			v:disconnect()
		end
	end
end
function t1.Clamp(p58, p59, p60) -- line: 301
	return (math.max(p58, (math.min(p59, p60))))
end
function t1.ClampVector2(p61, p62, p63) -- line: 305
	-- upvalues: t1 (copy)
	return Vector2.new(t1.Clamp(p61.x, p62.x, p63.x), t1.Clamp(p61.y, p62.y, p63.y))
end
function t1.TweenPositionOrSet(p64, ...) -- line: 309
	-- upvalues: EngineFeature (copy)
	if p64:IsDescendantOf(game) then
		if EngineFeature then
			p64:TweenPositionInternal(...)

			return
		end

		p64:TweenPosition(...)

		return
	end

	p64.Position = select(1, ...)
end
function t1.ClampCanvasPosition(p65, p66) -- line: 322
	-- upvalues: t1 (copy)
	local v107 = p65.Parent and p65.Parent.AbsoluteSize or Vector2.new(0, 0)
	local vector2 = Vector2.new(p65.CanvasSize.X.Scale * v107.X + p65.CanvasSize.X.Offset, p65.CanvasSize.Y.Scale * v107.Y + p65.CanvasSize.Y.Offset)
	local v109 = t1.Clamp(0, vector2.X - p65.AbsoluteWindowSize.X, p66.X)
	local v110 = t1.Clamp(0, vector2.Y - p65.AbsoluteWindowSize.Y, p66.Y)

	return Vector2.new(v109, v110)
end
function t1.Round(p67, p68) -- line: 333
	local v113 = p68 or 1

	return math.floor((p67 + v113 / 2) / v113) * v113
end
function t1.ChompString(p69) -- line: 341
	return tostring(p69):gsub("^%s+", ""):gsub("%s+$", "")
end
function t1.SpaceNormalizeString(p70) -- line: 346
	return tostring(p70):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function getDelimiterByLocale() -- line: 350
	-- upvalues: LocalizationService (copy)
	local v116 = LocalizationService.RobloxLocaleId:lower()
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

	if t6[v116] then
		return t6[v116]
	end

	return ","
end

function t1.FormatNumberString(p71) -- line: 381
	-- upvalues: getDelimiterByLocale (copy), t1 (copy)
	local v119 = getDelimiterByLocale()
	local v120 = t1.ChompString(p71)
	local v121 = string.format("%%1%s%%2", v119)

	repeat
		local count

		v120, count = string.gsub(v120, "^(-?%d+)(%d%d%d)", v121)
	until count == 0

	return v120
end
function t1.PrettyPrint(p72) -- line: 397
	-- upvalues: t1 (copy)
	if type(p72) == "table" then
		local s1 = "{"

		for k, v in pairs(p72) do
			local v127 = s1 == "{" and s1 or s1 .. ", "

			if type(k) == "string" then
				v127 ..= k .. " = "
			elseif type(k) ~= "number" then
				v127 ..= "[" .. k .. "] = "
			end

			s1 = v127 .. t1.PrettyPrint(v)
		end

		return s1 .. "}"
	end

	if type(p72) == "string" then
		return "'" .. p72 .. "'"
	end

	return (tostring(p72))
end

local function SCurveTranform(p73, p74, p75) -- line: 421
	-- upvalues: t1 (copy)
	local v131 = p74 or 0.35
	local v132 = p75 or 0.8
	local v133 = t1.Clamp(-1, 1, p73)

	if v133 >= 0 then
		return v131 * v133 / (v131 - v133 + 1)
	end

	return -(v132 * -v133 / (v132 + v133 + 1))
end
local function toSCurveSpace(p76, p77) -- line: 431
	local v136 = p77 or 0.1

	return (1 + v136) * (math.abs(p76) * 2 - 1) - v136
end
local function fromSCurveSpace(p78) -- line: 436
	return p78 / 2 + 0.5
end

function t1.GamepadLinearToCurve(p79, p80, _, _) -- line: 440
	-- upvalues: t1 (copy)
	local function onAxis(p83) -- line: 441
		-- upvalues: p80 (copy), t1 (copy)
		local v233 = not (p83 < 0) and 1 or -1
		local v234 = math.abs(p83)
		local v235 = p80 or 0.1
		local v236 = (1 + v235) * (math.abs(v234) * 2 - 1) - v235
		local v237 = nil or 0.35
		local v238 = nil or 0.8
		local v239 = t1.Clamp(-1, 1, v236)
		local v240 = ((if not (v239 >= 0) then -(v238 * -v239 / (v238 + v239 + 1)) else v237 * v239 / (v237 - v239 + 1))) / 2 + 0.5

		return t1.Clamp(-1, 1, v240 * v233)
	end

	local new = Vector2.new
	local x = p79.x
	local v145 = not (x < 0) and 1 or -1
	local v146 = math.abs(x)
	local v147 = p80 or 0.1
	local v148 = (1 + v147) * (math.abs(v146) * 2 - 1) - v147
	local v149 = nil or 0.35
	local v150 = nil or 0.8
	local v151 = t1.Clamp(-1, 1, v148)
	local v152 = ((if not (v151 >= 0) then -(v150 * -v151 / (v150 + v151 + 1)) else v149 * v151 / (v149 - v151 + 1))) / 2 + 0.5

	return new(t1.Clamp(-1, 1, v152 * v145), onAxis(p79.y))
end
function t1.IsFastFlagEnabled(p84) -- line: 450
	local ok, result = pcall(function() -- line: 451
		-- upvalues: p84 (copy)
		return settings():GetFFlag(p84)
	end)

	return ok and result
end
function t1.GetFastVariable(p85) -- line: 458
	local ok, result = pcall(function() -- line: 459
		-- upvalues: p85 (copy)
		return settings():GetFVariable(p85)
	end)

	return ok and result
end

local function getLocalPlayer() -- line: 466
	-- upvalues: Players (copy)
	while Players.LocalPlayer == nil do
		wait()
	end

	return Players.LocalPlayer
end

function t1.IsFeatureNonZero(p86) -- line: 473
	-- upvalues: t1 (copy)
	return (tonumber(t1.GetFastVariable(p86)) or 0) ~= 0
end
function t1.IsFeatureRolledOut(p87) -- line: 477
	-- upvalues: Players (copy), t1 (copy)
	while Players.LocalPlayer == nil do
		wait()
	end

	return Players.LocalPlayer.UserId % 100 < (tonumber(t1.GetFastVariable(p87)) or 0)
end
function t1.ExponentialRepeat(p88, p89, p90) -- line: 482
	local v164 = p90 or 6
	local n2 = 1

	while n2 <= v164 and p88() do
		if p89() then
			return
		end

		wait(n2 ^ 2)
		n2 += 1
	end
end
function t1.SplitString(p91, p92) -- line: 496
	local t7 = {}

	if p91 and p92 then
		for match in string.gmatch(p91, "([^" .. p92 .. "]+)") do
			table.insert(t7, match)
		end
	end

	return t7
end

local function findAssetsHelper(p93, p94, p95) -- line: 507
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

function t1.FindAssetsInModel(p96, p97) -- line: 535
	-- upvalues: findAssetsHelper (copy)
	local v177 = p97 or "https://assetgame.roblox.com/asset/?id="
	local t8 = {}

	findAssetsHelper(p96, t8, v177)

	return t8
end
function t1.ConvertFontSizeEnumToInt(p98) -- line: 542
	local p98Name = p98.Name

	return string.match(p98Name, "%d+") or 10
end
function t1.Upper(p99) -- line: 549
	-- upvalues: PlatformService (ref)
	if PlatformService then
		return PlatformService:Upper(p99)
	end

	return string.upper(p99)
end
function t1.SetSelectedCoreObject(p100) -- line: 557
	-- upvalues: GuiService (copy)
	GuiService.SelectedCoreObject = p100
end
function t1.AddSelectionParent(p101, p102) -- line: 561
	-- upvalues: GuiService (copy)
	GuiService:AddSelectionParent(p101, p102)
end
function t1.RemoveSelectionGroup(p103) -- line: 565
	-- upvalues: GuiService (copy)
	GuiService:RemoveSelectionGroup(p103)
end
function t1.GetTextBounds(p104) -- line: 569
	-- upvalues: TextService (copy)
	local v187 = false
	local TextSize = nil

	if p104 then
		if p104.TextFits then
			return true, p104.TextBounds
		end

		if not p104.TextWrapped then
			TextSize = TextService:GetTextSize(p104.Text, p104.TextSize, p104.Font, Vector2.new(0, 0))
			v187 = true
		end
	end

	return v187, TextSize
end
function t1.ResizeButtonWithText(p105, p106, p107, p108) -- line: 595
	-- upvalues: t1 (copy)
	local v193 = false
	local v194, v195 = t1.GetTextBounds(p106)

	if v194 and (p105.Size.X.Scale == 0 and p105.Size.Y.Scale == 0) then
		local vector2 = Vector2.new(p105.Size.X.Offset, p105.Size.Y.Offset)
		local vector2X = vector2.X
		local vector2Y = vector2.Y

		if p107 and vector2.X < v195.X + p107 * 2 then
			vector2X = v195.X + p107 * 2
			v193 = true
		end

		if p108 and vector2.Y < v195.Y + p108 * 2 then
			vector2Y = v195.Y + p108 * 2
			v193 = true
		end

		if v193 then
			p105.Size = UDim2.new(0, vector2X, 0, vector2Y)
		end
	end

	return v193
end
function t1.ResizeButtonWithDynamicText(p109, p110, p111, p112, p113) -- line: 622
	-- upvalues: t1 (copy)
	local v204 = t1.ResizeButtonWithText(p109, p110, p112, p113) or false
	local p110Text = p110.Text

	if p111 and #p111 > 0 then
		for i = 1, #p111 do
			p110.Text = p111[i]
			v204 = t1.ResizeButtonWithText(p109, p110, p112, p113) or v204
		end
	end

	p110.Text = p110Text

	return v204
end

return t1
