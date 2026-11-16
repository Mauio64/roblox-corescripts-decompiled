local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local v = nil
pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v = PlatformService
end)

local Utility = {}

function Utility.IsFinite(p): boolean
	return p == p and p ~= 1e999 and p ~= -1e999
end

function Utility.FindAncestorOfType(p, className)
	local parent = p and p.Parent

	if not parent then
		return nil
	end

	if parent:IsA(className) then
		return parent
	end

	return Utility.FindAncestorOfType(parent, className)
end

function Utility.CalculateRelativeDimensions(p, p2, p3, _)
	local v2 = GuiService:GetScreenResolution()
	local ancestorOfType = Utility.FindAncestorOfType(p, "SurfaceGui")

	if ancestorOfType then
		v2 = ancestorOfType.CanvasSize
	end

	local v3 = p2 / p3

	if p3.y > 0 and v2.y > 0 then
		v3 *= p3.x / p3.y / (v2.x / v2.y)
		local parent = p.Parent

		if parent then
			local v4 = 1 / (parent.AbsoluteSize / v2)

			if Utility.IsFinite(v4.x) and Utility.IsFinite(v4.y) then
				return UDim2.new(v4.x * v3.x, 0, v4.y * v3.y, 0)
			end
		end
	end

	return UDim2.new(v3.x, 0, v3.y, 0)
end

Utility.Enum = {
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

function Utility.CalculateFit(p, p2)
	local v2 = p.AbsoluteSize / p2
	local v3 = p2 * math.min(v2.X, v2.Y)

	return UDim2.new(0, v3.X, 0, v3.Y)
end

function Utility.CalculateFill(p, p2)
	local v2 = p.AbsoluteSize / p2
	local v3 = p2 * math.max(v2.X, v2.Y)

	return UDim2.new(0, v3.X, 0, v3.Y)
end

local v2 = {}

local function getActiveTween(p, p2) -- 3 equivalent calls inferred from this helper
	return v2[p] and v2[p][p2]
end

local function setActiveTween(p, p2, p3) -- 4 equivalent calls inferred from this helper
	if not v2[p] then
		v2[p] = {}
	end

	v2[p][p2] = p3
end

function Utility.Linear(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	return p3 * p / p4 + p2
end

function Utility.EaseOutQuad(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	p /= p4
	return -p3 * p * (p - 2) + p2
end

function Utility.EaseInOutQuad(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	local v3 = p / (p4 / 2)

	if v3 < 1 then
		return p3 / 2 * v3 * v3 + p2
	end

	v3 -= 1
	return -p3 / 2 * (v3 * (v3 - 2) - 1) + p2
end

function Utility.SCurveUDim2(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	p /= p4
	local v3 = p < 0 and 0 or p
	local v4 = v3 > 1 and 1 or v3
	local v5 = 3 * v4 * v4 - 2 * v4 * v4 * v4
	return UDim2.new(v5 * p3.X.Scale, v5 * p3.X.Offset, v5 * p3.Y.Scale, v5 * p3.Y.Offset) + p2
end

function Utility.SCurveVector2(p, p2, p3, p4)
	if p4 <= p then
		return p2 + p3
	end

	p /= p4
	local v3 = p < 0 and 0 or p
	local v4 = v3 > 1 and 1 or v3
	local v5 = 3 * v4 * v4 - 2 * v4 * v4 * v4
	return Vector2.new(v5 * p3.X, v5 * p3.Y) + p2
end

function Utility:PropertyTweener(p, p2, final, p3, p4, p5, callback)
	local v3 = p4 or Utility.Linear

	local v4 = {}
	v4.StartTime = tick()
	v4.EndTime = v4.StartTime + p3
	v4.Cancelled = false

	local v5 = false
	local percentComplete = 0

	local function setValue(p6) -- 3 equivalent calls inferred from this helper
		if self then
			self[p] = p6
		end
	end

	local function finalize()
		setValue(v3(1, p2, final - p2, 1)) -- inferred equivalent call
		v5 = true
		percentComplete = 1

		if getActiveTween(p, self) == v4 then -- inferred equivalent call
			setActiveTween(p, self) -- inferred equivalent call
		end

		if callback then
			callback()
		end
	end

	if p5 or not (v2[p] and v2[p][self]) then
		if v2[p] and v2[p][self] then
			(v2[p] and v2[p][self]):Cancel()
		end

		setActiveTween(p, self, v4) -- inferred equivalent call
		setValue(v3(0, p2, final - p2, p3)) -- inferred equivalent call
		spawn(function()
			local now = tick()

			while now < v4.EndTime and self and not v4.Cancelled do
				setValue(v3(now - v4.StartTime, p2, final - p2, p3)) -- inferred equivalent call
				percentComplete = Utility.Clamp(0, 1, (now - v4.StartTime) / p3)
				RunService.RenderStepped:wait()
				now = tick()
			end

			if v4.Cancelled == false and self then
				finalize()
			end

			if getActiveTween(p, self) == v4 then -- inferred equivalent call
				setActiveTween(p, self) -- inferred equivalent call
			end
		end)
	else
		v5 = true
	end

	function v4.GetFinal(_)
		return final
	end

	function v4.GetPercentComplete(_)
		return percentComplete
	end

	function v4.IsFinished(_)
		return v5
	end

	function v4:Finish()
		if not v5 then
			self:Cancel()
			finalize()
		end
	end

	function v4.Cancel(_)
		v4.Cancelled = true
		v5 = true

		if getActiveTween(p, self) == v4 then -- inferred equivalent call
			setActiveTween(p, self) -- inferred equivalent call
		end
	end

	return v4
end

function Utility:CancelTweens()
	for k, item in pairs(self) do
		item:Finish()
		self[k] = nil
	end
end

function Utility.Signal()
	local bindableEvent = Instance.new("BindableEvent")

	local v3 = nil
	local v4 = nil
	return {
		fire = function(_, ...)
			v3 = { ... }
			v4 = select("#", ...)
			bindableEvent:Fire()
		end,
		connect = function(self, callback)
			if not callback then
				error("connect(nil)", 2)
			end

			return bindableEvent.Event:connect(function()
				callback(unpack(v3, 1, v4))
			end)
		end,
		wait = function(self)
			bindableEvent.Event:wait()
			assert(v3, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
			return unpack(v3, 1, v4)
		end
	}
end

function Utility.DisconnectEvent(object): nil
	if object then
		object:disconnect()
	end

	return nil
end

function Utility.DisconnectEvents(items)
	if items and type(items) == "table" then
		for _, item in pairs(items) do
			item:disconnect()
		end
	end
end

function Utility.Clamp(p, p2, p3)
	return (math.max(p, (math.min(p2, p3))))
end

function Utility.ClampVector2(p, p2, p3)
	return Vector2.new(Utility.Clamp(p.x, p2.x, p3.x), Utility.Clamp(p.y, p2.y, p3.y))
end

function Utility:TweenPositionOrSet(...)
	if self:IsDescendantOf(game) then
		self:TweenPositionInternal(...)
	else
		self.Position = select(1, ...)
	end
end

function Utility.ClampCanvasPosition(data, p)
	local absoluteSize = data.Parent and data.Parent.AbsoluteSize or Vector2.new(0, 0)
	local vector2 = Vector2.new(
		data.CanvasSize.X.Scale * absoluteSize.X + data.CanvasSize.X.Offset,
		data.CanvasSize.Y.Scale * absoluteSize.Y + data.CanvasSize.Y.Offset
	)
	local clamped = Utility.Clamp(0, vector2.X - data.AbsoluteWindowSize.X, p.X)
	local clamped2 = Utility.Clamp(0, vector2.Y - data.AbsoluteWindowSize.Y, p.Y)

	return Vector2.new(clamped, clamped2)
end

function Utility.Round(p, value)
	value = value or 1
	return math.floor((p + value / 2) / value) * value
end

function Utility.ChompString(p)
	return tostring(p):gsub("^%s+", ""):gsub("%s+$", "")
end

function Utility.SpaceNormalizeString(p)
	return tostring(p):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function getDelimiterByLocale()
	local robloxLocaleId = LocalizationService.RobloxLocaleId:lower()

	local v3 = {
		["en-us"] = ",",
		["zh-hk"] = "",
		["zh-tw"] = "",
		["nb-no"] = " ",
		["es-es"] = " ",
		["nl-nl"] = ".",
		["it-it"] = ".",
		["tr-tr"] = ".",
		["ru-ru"] = " ",
		["fi-fi"] = " ",
		["da-dk"] = ".",
		["de-de"] = ".",
		["fr-fr"] = " ",
		["pt-br"] = ".",
		["pt-pt"] = ".",
		["pl-pl"] = " ",
		["sv-se"] = " "
	}

	if v3[robloxLocaleId] then
		return v3[robloxLocaleId]
	end

	return ","
end

function Utility.FormatNumberString(p)
	local delimiterByLocale = getDelimiterByLocale()

	local chompString = Utility.ChompString(p)
	local v3 = string.format("%%1%s%%2", delimiterByLocale)

	repeat
		local v4
		chompString, v4 = string.gsub(chompString, "^(-?%d+)(%d%d%d)", v3)
	until v4 == 0

	return chompString
end

function Utility.PrettyPrint(value)
	if type(value) == "table" then
		local v3 = "{"

		for k, item in pairs(value) do
			local v4 = v3 == "{" and v3 or v3 .. ", "

			if type(k) == "string" then
				v4 ..= k .. " = "
			elseif type(k) ~= "number" then
				v4 ..= "[" .. k .. "] = "
			end

			v3 = v4 .. Utility.PrettyPrint(item)
		end

		return v3 .. "}"
	elseif type(value) == "string" then
		return "'" .. value .. "'"
	else
		return (tostring(value))
	end
end

local function SCurveTranform(p, value, value2) -- 1 equivalent call inferred from this helper
	local v3 = value or 0.35
	local v4 = value2 or 0.8
	local clamped = Utility.Clamp(-1, 1, p)

	if clamped >= 0 then
		return v3 * clamped / (v3 - clamped + 1)
	end

	return -(v4 * -clamped / (v4 + clamped + 1))
end

local function toSCurveSpace(p, value) -- 1 equivalent call inferred from this helper
	local v3 = value or 0.1
	return (1 + v3) * (math.abs(p) * 2 - 1) - v3
end

local function fromSCurveSpace(p) -- 1 equivalent call inferred from this helper
	return p / 2 + 0.5
end

function Utility.GamepadLinearToCurve(p, value, _, _)
	local function onAxis(y) -- 1 equivalent call inferred from this helper
		local v3 = y < 0 and -1 or 1

		local v4 = fromSCurveSpace(SCurveTranform(toSCurveSpace(math.abs(y), value), nil)) -- inferred equivalent call
		return Utility.Clamp(-1, 1, v4 * v3)
	end

	return Vector2.new(onAxis(p.x), onAxis(p.y)) -- inferred equivalent call
end

function Utility.IsFastFlagEnabled(p)
	local success, result = pcall(function()
		return settings():GetFFlag(p)
	end)

	return success and result
end

function Utility.GetFastVariable(p)
	local success, result = pcall(function()
		return settings():GetFVariable(p)
	end)

	return success and result
end

local function getLocalPlayer() -- 1 equivalent call inferred from this helper
	while Players.LocalPlayer == nil do
		wait()
	end

	return Players.LocalPlayer
end

function Utility.IsFeatureNonZero(p): boolean
	return (tonumber(Utility.GetFastVariable(p)) or 0) ~= 0
end

function Utility.IsFeatureRolledOut(p): boolean
	return getLocalPlayer().UserId % 100 < (tonumber(Utility.GetFastVariable(p)) or 0) -- inferred equivalent call
end

function Utility.ExponentialRepeat(callback, callback2, value)
	local v3 = 1
	local v4 = value or 6

	while v3 <= v4 and callback() do
		if callback2() then
			break
		end

		wait(v3 ^ 2)
		v3 += 1
	end
end

function Utility.SplitString(value, p)
	local result = {}

	if value and p then
		for k in string.gmatch(value, "([^" .. p .. "]+)") do
			table.insert(result, k)
		end
	end

	return result
end

local function findAssetsHelper(instance, list, p)
	if not instance then
		return
	end

	if instance:IsA("CharacterMesh") then
		if instance.MeshId > 0 then
			table.insert(list, p .. tostring(instance.MeshId))
		end

		if instance.BaseTextureId > 0 then
			table.insert(list, p .. tostring(instance.BaseTextureId))
		end

		if instance.OverlayTextureId > 0 then
			table.insert(list, p .. tostring(instance.OverlayTextureId))
		end
	elseif instance:IsA("FileMesh") then
		table.insert(list, instance.MeshId)
		table.insert(list, instance.TextureId)
	elseif instance:IsA("Decal") then
		table.insert(list, instance.Texture)
	elseif instance:IsA("Pants") then
		table.insert(list, instance.PantsTemplate)
	elseif instance:IsA("Shirt") then
		table.insert(list, instance.ShirtTemplate)
	end

	for _, child in pairs(instance:GetChildren()) do
		findAssetsHelper(child, list, p)
	end
end
function Utility.FindAssetsInModel(p, value)
	local assetsInModel = {}
	findAssetsHelper(p, assetsInModel, value or "https://assetgame.roblox.com/asset/?id=")
	return assetsInModel
end

function Utility.ConvertFontSizeEnumToInt(p)
	local name = p.Name

	return string.match(name, "%d+") or 10
end

function Utility:Upper()
	if v then
		return v:Upper(self)
	end

	return string.upper(self)
end

function Utility.SetSelectedCoreObject(selectedCoreObject)
	GuiService.SelectedCoreObject = selectedCoreObject
end

function Utility:AddSelectionParent(p)
	GuiService:AddSelectionParent(self, p)
end

function Utility:RemoveSelectionGroup()
	GuiService:RemoveSelectionGroup(self)
end

function Utility.GetTextBounds(data)
	local v3 = false
	local textSize = nil

	if not data then
		return false, textSize
	end

	if data.TextFits then
		return true, data.TextBounds
	end

	if not data.TextWrapped then
		textSize = TextService:GetTextSize(data.Text, data.TextSize, data.Font, Vector2.new(0, 0))
		v3 = true
	end

	return v3, textSize
end

function Utility:ResizeButtonWithText(p, p2, p3)
	local flag = false
	local textBounds, v3 = Utility.GetTextBounds(p)

	if not textBounds or self.Size.X.Scale ~= 0 or self.Size.Y.Scale ~= 0 then
		return false
	end

	local vector2 = Vector2.new(self.Size.X.Offset, self.Size.Y.Offset)
	local v4 = vector2.X
	local v5 = vector2.Y

	if p2 and vector2.X < v3.X + p2 * 2 then
		v4 = v3.X + p2 * 2
		flag = true
	end

	if p3 and vector2.Y < v3.Y + p3 * 2 then
		v5 = v3.Y + p3 * 2
		flag = true
	end

	if flag then
		self.Size = UDim2.new(0, v4, 0, v5)
	end

	return flag
end

function Utility.ResizeButtonWithDynamicText(p, p2, list, p3, p4)
	local v3 = Utility.ResizeButtonWithText(p, p2, p3, p4) or false
	local text = p2.Text

	if list and #list > 0 then
		for i = 1, #list do
			p2.Text = list[i]
			v3 = Utility.ResizeButtonWithText(p, p2, p3, p4) or v3
		end
	end

	p2.Text = text
	return v3
end

return Utility
