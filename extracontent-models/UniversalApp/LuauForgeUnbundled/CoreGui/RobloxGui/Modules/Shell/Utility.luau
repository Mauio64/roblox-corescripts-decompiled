local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local LocalizationService = game:GetService("LocalizationService")

local v5 = nil
pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v5 = PlatformService
end)

local v6 = {}

function v6.IsFinite(p2): boolean
	return p2 == p2 and p2 ~= 1e999 and p2 ~= -1e999
end

function v6.FindAncestorOfType(p2, className)
	local parent = p2 and p2.Parent

	if not parent then
		return nil
	end

	if parent:IsA(className) then
		return parent
	end

	return v6.FindAncestorOfType(parent, className)
end

function v6.CalculateRelativeDimensions(p2, p3, p4, p5)
	local v7 = GuiService:GetScreenResolution()
	local ancestorOfType = v6.FindAncestorOfType(p2, "SurfaceGui")

	if ancestorOfType then
		v7 = ancestorOfType.CanvasSize
	end

	local v8 = p3 / p4

	if p4.y > 0 and v7.y > 0 then
		v8 *= p4.x / p4.y / (v7.x / v7.y)
		local parent = p2.Parent

		if parent then
			local v9 = 1 / (parent.AbsoluteSize / v7)

			if v6.IsFinite(v9.x) and v6.IsFinite(v9.y) then
				return UDim2.new(v9.x * v8.x, 0, v9.y * v8.y, 0)
			end
		end
	end

	return UDim2.new(v8.x, 0, v8.y, 0)
end

v6.Enum = {
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

function v6.CalculateFit(p2, p3)
	local v7 = p2.AbsoluteSize / p3
	local v8 = p3 * math.min(v7.X, v7.Y)

	return UDim2.new(0, v8.X, 0, v8.Y)
end

function v6.CalculateFill(p2, p3)
	local v7 = p2.AbsoluteSize / p3
	local v8 = p3 * math.max(v7.X, v7.Y)

	return UDim2.new(0, v8.X, 0, v8.Y)
end

local v7 = {}

local function getActiveTween(p2, p3)
	return v7[p2] and v7[p2][p3]
end

local function setActiveTween(p2, p3, p4)
	if not v7[p2] then
		v7[p2] = {}
	end

	v7[p2][p3] = p4
end

function v6.Linear(p2, p3, p4, p5)
	if p5 <= p2 then
		return p3 + p4
	end

	return p4 * p2 / p5 + p3
end

function v6.EaseOutQuad(p2, p3, p4, p5)
	if p5 <= p2 then
		return p3 + p4
	end

	local v8 = p2 / p5
	return -p4 * v8 * (v8 - 2) + p3
end

function v6.EaseInOutQuad(p2, p3, p4, p5)
	if p5 <= p2 then
		return p3 + p4
	end

	local v8 = p2 / (p5 / 2)

	if v8 < 1 then
		return p4 / 2 * v8 * v8 + p3
	end

	local v9 = v8 - 1
	return -p4 / 2 * (v9 * (v9 - 2) - 1) + p3
end

function v6.SCurveUDim2(p2, p3, p4, p5)
	if p5 <= p2 then
		return p3 + p4
	end

	local v8 = p2 / p5
	local v9 = v8 < 0 and 0 or v8
	local v10 = v9 > 1 and 1 or v9
	local v11 = 3 * v10 * v10 - 2 * v10 * v10 * v10
	return UDim2.new(v11 * p4.X.Scale, v11 * p4.X.Offset, v11 * p4.Y.Scale, v11 * p4.Y.Offset) + p3
end

function v6.SCurveVector2(p2, p3, p4, p5)
	if p5 <= p2 then
		return p3 + p4
	end

	local v8 = p2 / p5
	local v9 = v8 < 0 and 0 or v8
	local v10 = v9 > 1 and 1 or v9
	local v11 = 3 * v10 * v10 - 2 * v10 * v10 * v10
	return Vector2.new(v11 * p4.X, v11 * p4.Y) + p3
end

function v6:PropertyTweener(p3, p4, final, p5, p6, p7, callback)
	local v8 = p6 or v6.Linear

	local v9 = {}
	v9.StartTime = tick()
	v9.EndTime = v9.StartTime + p5
	v9.Cancelled = false

	local v10 = false
	local percentComplete = 0

	local function setValue(p8)
		if self then
			self[p3] = p8
		end
	end

	local function finalize()
		local v11 = v8(1, p4, final - p4, 1)

		if self then
			self[p3] = v11
		end

		v10 = true
		percentComplete = 1

		local v12 = p3

		if (v7[v12] and v7[v12][self]) == v9 then
			local v14 = p3

			if not v7[v14] then
				v7[v14] = {}
			end

			v7[v14][self] = nil
		end

		if callback then
			callback()
		end
	end

	if p7 or not (v7[p3] and v7[p3][self]) then
		if v7[p3] and v7[p3][self] then
			(v7[p3] and v7[p3][self]):Cancel()
		end

		if not v7[p3] then
			v7[p3] = {}
		end

		v7[p3][self] = v9

		local v11 = v8(0, p4, final - p4, p5)

		if self then
			self[p3] = v11
		end

		spawn(function()
			local now = tick()

			while now < v9.EndTime and self and not v9.Cancelled do
				local v12 = v8(now - v9.StartTime, p4, final - p4, p5)

				if self then
					self[p3] = v12
				end

				percentComplete = v6.Clamp(0, 1, (now - v9.StartTime) / p5)
				RunService.RenderStepped:wait()
				now = tick()
			end

			if v9.Cancelled == false and self then
				finalize()
			end

			local v12 = p3

			if (v7[v12] and v7[v12][self]) == v9 then
				local v14 = p3

				if not v7[v14] then
					v7[v14] = {}
				end

				v7[v14][self] = nil
			end
		end)
	else
		v10 = true
	end

	function v9.GetFinal(p8)
		return final
	end

	function v9.GetPercentComplete(p8)
		return percentComplete
	end

	function v9.IsFinished(p8)
		return v10
	end

	function v9:Finish()
		if not v10 then
			self:Cancel()
			finalize()
		end
	end

	function v9.Cancel(p8)
		v9.Cancelled = true
		v10 = true
		local v11 = p3

		if (v7[v11] and v7[v11][self]) == v9 then
			local v13 = p3

			if not v7[v13] then
				v7[v13] = {}
			end

			v7[v13][self] = nil
		end
	end

	return v9
end

function v6:CancelTweens()
	for k, item in pairs(self) do
		item:Finish()
		self[k] = nil
	end
end

function v6.Signal()
	local bindableEvent = Instance.new("BindableEvent")

	local v9 = nil
	local v10 = nil
	return {
		fire = function(self, ...)
			v9 = { ... }
			v10 = select("#", ...)
			bindableEvent:Fire()
		end,
		connect = function(p2, callback)
			if not callback then
				error("connect(nil)", 2)
			end

			return bindableEvent.Event:connect(function()
				callback(unpack(v9, 1, v10))
			end)
		end,
		wait = function(p2)
			bindableEvent.Event:wait()
			assert(v9, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
			return unpack(v9, 1, v10)
		end
	}
end

function v6.DisconnectEvent(object): nil
	if object then
		object:disconnect()
	end

	return nil
end

function v6.DisconnectEvents(items)
	if items and type(items) == "table" then
		for k, item in pairs(items) do
			item:disconnect()
		end
	end
end

function v6.Clamp(p2, p3, p4)
	return (math.max(p2, (math.min(p3, p4))))
end

function v6.ClampVector2(p2, p3, p4)
	return Vector2.new(v6.Clamp(p2.x, p3.x, p4.x), v6.Clamp(p2.y, p3.y, p4.y))
end

function v6:TweenPositionOrSet(...)
	if self:IsDescendantOf(game) then
		self:TweenPositionInternal(...)
	else
		self.Position = select(1, ...)
	end
end

function v6.ClampCanvasPosition(data, p2)
	local absoluteSize = data.Parent and data.Parent.AbsoluteSize or Vector2.new(0, 0)
	local vector2 = Vector2.new(
		data.CanvasSize.X.Scale * absoluteSize.X + data.CanvasSize.X.Offset,
		data.CanvasSize.Y.Scale * absoluteSize.Y + data.CanvasSize.Y.Offset
	)
	local clamped = v6.Clamp(0, vector2.X - data.AbsoluteWindowSize.X, p2.X)
	local clamped2 = v6.Clamp(0, vector2.Y - data.AbsoluteWindowSize.Y, p2.Y)

	return Vector2.new(clamped, clamped2)
end

function v6.Round(p2, value)
	local v8 = value or 1
	return math.floor((p2 + v8 / 2) / v8) * v8
end

function v6.ChompString(p2)
	return tostring(p2):gsub("^%s+", ""):gsub("%s+$", "")
end

function v6.SpaceNormalizeString(p2)
	return tostring(p2):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function getDelimiterByLocale()
	local robloxLocaleId = LocalizationService.RobloxLocaleId:lower()

	local v8 = {
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

	if v8[robloxLocaleId] then
		return v8[robloxLocaleId]
	end

	return ","
end

function v6.FormatNumberString(p2)
	local delimiterByLocale = getDelimiterByLocale()

	local chompString = v6.ChompString(p2)
	local v8 = string.format("%%1%s%%2", delimiterByLocale)

	repeat
		local v9
		chompString, v9 = string.gsub(chompString, "^(-?%d+)(%d%d%d)", v8)
	until v9 == 0

	return chompString
end

function v6.PrettyPrint(value)
	if type(value) == "table" then
		local v8 = "{"

		for k, item in pairs(value) do
			local v9 = v8 == "{" and v8 or v8 .. ", "

			if type(k) == "string" then
				v9 ..= k .. " = "
			elseif type(k) ~= "number" then
				v9 ..= "[" .. k .. "] = "
			end

			v8 = v9 .. v6.PrettyPrint(item)
		end

		return v8 .. "}"
	elseif type(value) == "string" then
		return "'" .. value .. "'"
	else
		return (tostring(value))
	end
end

local function SCurveTranform(p2, value, value2)
	local v8 = value or 0.35
	local v9 = value2 or 0.8
	local clamped = v6.Clamp(-1, 1, p2)

	if clamped >= 0 then
		return v8 * clamped / (v8 - clamped + 1)
	end

	return -(v9 * -clamped / (v9 + clamped + 1))
end

local function toSCurveSpace(p2, value)
	local v8 = value or 0.1
	return (1 + v8) * (math.abs(p2) * 2 - 1) - v8
end

local function fromSCurveSpace(p2)
	return p2 / 2 + 0.5
end

function v6.GamepadLinearToCurve(p2, value, p3, p4)
	local function onAxis(y)
		local v8 = y < 0 and -1 or 1

		local v9 = math.abs(y)
		local v10 = value or 0.1
		local v11 = (1 + v10) * (math.abs(v9) * 2 - 1) - v10
		local v12 = nil or 0.35
		local v13 = nil or 0.8
		local clamped = v6.Clamp(-1, 1, v11)

		local v15 = (if clamped >= 0 then v12 * clamped / (v12 - clamped + 1) else -(v13 * -clamped / (v13 + clamped + 1))) / 2 + 0.5

		return v6.Clamp(-1, 1, v15 * v8)
	end

	local newVector2 = Vector2.new
	local x = p2.x
	local v8 = x < 0 and -1 or 1

	local v9 = math.abs(x)
	local v10 = value or 0.1
	local v11 = (1 + v10) * (math.abs(v9) * 2 - 1) - v10
	local v12 = nil or 0.35
	local v13 = nil or 0.8
	local clamped = v6.Clamp(-1, 1, v11)

	local v15 = (if clamped >= 0 then v12 * clamped / (v12 - clamped + 1) else -(v13 * -clamped / (v13 + clamped + 1))) / 2 + 0.5

	return newVector2(v6.Clamp(-1, 1, v15 * v8), onAxis(p2.y))
end

function v6.IsFastFlagEnabled(p2)
	local success, result = pcall(function()
		return settings():GetFFlag(p2)
	end)

	return success and result
end

function v6.GetFastVariable(p2)
	local success, result = pcall(function()
		return settings():GetFVariable(p2)
	end)

	return success and result
end

local function getLocalPlayer()
	while Players.LocalPlayer == nil do
		wait()
	end

	return Players.LocalPlayer
end

function v6.IsFeatureNonZero(p2): boolean
	return (tonumber(v6.GetFastVariable(p2)) or 0) ~= 0
end

function v6.IsFeatureRolledOut(p2): boolean
	while Players.LocalPlayer == nil do
		wait()
	end

	return Players.LocalPlayer.UserId % 100 < (tonumber(v6.GetFastVariable(p2)) or 0)
end

function v6.ExponentialRepeat(callback, callback2, value)
	local v8 = 1
	local v9 = value or 6

	while v8 <= v9 and callback() do
		if callback2() then
			break
		end

		wait(v8 ^ 2)
		v8 += 1
	end
end

function v6.SplitString(value, p2)
	local result = {}

	if value and p2 then
		for k in string.gmatch(value, "([^" .. p2 .. "]+)") do
			table.insert(result, k)
		end
	end

	return result
end

local function findAssetsHelper(instance, list, p2)
	if not instance then
		return
	end

	if instance:IsA("CharacterMesh") then
		if instance.MeshId > 0 then
			table.insert(list, p2 .. tostring(instance.MeshId))
		end

		if instance.BaseTextureId > 0 then
			table.insert(list, p2 .. tostring(instance.BaseTextureId))
		end

		if instance.OverlayTextureId > 0 then
			table.insert(list, p2 .. tostring(instance.OverlayTextureId))
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

	for i, child in pairs(instance:GetChildren()) do
		findAssetsHelper(child, list, p2)
	end
end
function v6.FindAssetsInModel(p2, value)
	local assetsInModel = {}
	findAssetsHelper(p2, assetsInModel, value or "https://assetgame.roblox.com/asset/?id=")
	return assetsInModel
end

function v6.ConvertFontSizeEnumToInt(p2)
	local name = p2.Name

	return string.match(name, "%d+") or 10
end

function v6:Upper()
	if v5 then
		return v5:Upper(self)
	end

	return string.upper(self)
end

function v6.SetSelectedCoreObject(selectedCoreObject)
	GuiService.SelectedCoreObject = selectedCoreObject
end

function v6:AddSelectionParent(p3)
	GuiService:AddSelectionParent(self, p3)
end

function v6:RemoveSelectionGroup()
	GuiService:RemoveSelectionGroup(self)
end

function v6.GetTextBounds(data)
	local v8 = false
	local textSize = nil

	if not data then
		return false, textSize
	end

	if data.TextFits then
		return true, data.TextBounds
	end

	if not data.TextWrapped then
		textSize = TextService:GetTextSize(data.Text, data.TextSize, data.Font, Vector2.new(0, 0))
		v8 = true
	end

	return v8, textSize
end

function v6:ResizeButtonWithText(p3, p4, p5)
	local flag = false
	local textBounds, v8 = v6.GetTextBounds(p3)

	if not textBounds or self.Size.X.Scale ~= 0 or self.Size.Y.Scale ~= 0 then
		return false
	end

	local vector2 = Vector2.new(self.Size.X.Offset, self.Size.Y.Offset)
	local v9 = vector2.X
	local v10 = vector2.Y

	if p4 and vector2.X < v8.X + p4 * 2 then
		v9 = v8.X + p4 * 2
		flag = true
	end

	if p5 and vector2.Y < v8.Y + p5 * 2 then
		v10 = v8.Y + p5 * 2
		flag = true
	end

	if flag then
		self.Size = UDim2.new(0, v9, 0, v10)
	end

	return flag
end

function v6.ResizeButtonWithDynamicText(p2, p3, list, p4, p5)
	local v8 = v6.ResizeButtonWithText(p2, p3, p4, p5) or false
	local text = p3.Text

	if list and #list > 0 then
		for i = 1, #list do
			p3.Text = list[i]
			v8 = v6.ResizeButtonWithText(p2, p3, p4, p5) or v8
		end
	end

	p3.Text = text
	return v8
end

return v6
