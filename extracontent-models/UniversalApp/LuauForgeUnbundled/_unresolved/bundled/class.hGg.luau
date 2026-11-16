local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local OBSERVED_IMAGE_TAG = require("@luauforge/bundled/hGa").OBSERVED_IMAGE_TAG

local defineFastFlag = game:DefineFastFlag("DebugEnableImageLoadObserver", false)

local color = Color3.fromRGB(40, 140, 240)
local color2 = Color3.fromRGB(40, 230, 90)

local class = {}
class.__index = class

function class.isEnabled()
	return defineFastFlag
end

function class.new()
	local object = setmetatable({ strokes = {}, connection = nil }, class)

	if defineFastFlag then
		object.connection = RunService.Heartbeat:Connect(function()
			object:_outlineTagged()
		end)
	end

	return object
end

function class:_ensureStroke(parent)
	local stroke = self.strokes[parent]

	if stroke and stroke.Parent == parent then
		return stroke
	end

	local imageLoadObserverDebugStroke = Instance.new("UIStroke")
	imageLoadObserverDebugStroke.Name = "ImageLoadObserverDebugStroke"
	imageLoadObserverDebugStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	imageLoadObserverDebugStroke.Color = color
	imageLoadObserverDebugStroke.Thickness = 3
	imageLoadObserverDebugStroke.Transparency = 0
	imageLoadObserverDebugStroke.Parent = parent

	self.strokes[parent] = imageLoadObserverDebugStroke
	return imageLoadObserverDebugStroke
end

function class:_removeStroke(p3)
	local stroke = self.strokes[p3]
	self.strokes[p3] = nil

	if stroke then
		stroke:Destroy()
	end
end

function class:_outlineTagged()
	local guiObjectSet = {}

	for k, guiObject in CollectionService:GetTagged(OBSERVED_IMAGE_TAG) do
		if not guiObject:IsA("GuiObject") then
			continue
		end

		guiObjectSet[guiObject] = true
		self:_ensureStroke(guiObject)
	end

	for k in self.strokes do
		if not guiObjectSet[k] then
			self:_removeStroke(k)
		end
	end
end

function class:flash(guiObject)
	if not defineFastFlag or (guiObject == nil or not guiObject:IsA("GuiObject")) then
		return
	end

	local stroke = self:_ensureStroke(guiObject)
	stroke.Color = color2
	stroke.Thickness = 6

	task.delay(2.5, function()
		if stroke.Parent ~= nil then
			stroke.Color = color
			stroke.Thickness = 3
		end
	end)
end

function class:flashAndDestroy(p2)
	if not defineFastFlag then
		return
	end

	self:flash(p2)

	task.delay(2.5, function()
		self:destroy()
	end)
end

function class:destroy()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end

	for k in self.strokes do
		self:_removeStroke(k)
	end
end

return class
