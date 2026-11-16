local CorePackages = game:GetService("CorePackages")

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection

require("@luauforge/bundled/dHK")

local fFlagAXUseSignalsForApplyingLayeredClothing = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForApplyingLayeredClothing
local getApplyingLayeredClothingStore

if fFlagAXUseSignalsForApplyingLayeredClothing then
	getApplyingLayeredClothingStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getApplyingLayeredClothingStore
else
	getApplyingLayeredClothingStore = nil
end

local extended = Roact.PureComponent:extend("AvatarLoadingSpinner")

extended.validateProps = t.interface({
	currentCharacter = t.optional(t.instanceIsA("Model")),
	layeredClothingLoading = t.boolean,
	hasAvatarData = t.boolean,
	ppeEmoteLoading = t.optional(t.boolean)
})

function extended:init()
	self.containerRef = Roact.createRef()

	local binding, v5 = Roact.createBinding(nil)
	self.characterScreenPosition = binding
	self.updateCharacterScreenPosition = v5
	local binding2, v6 = Roact.createBinding(nil)
	self.containerPositon = binding2
	self.updateContainerPosition = v6

	self.positionBinding = Roact.joinBindings({
		characterScreenPosition = self.characterScreenPosition,
		containerPositon = self.containerPositon
	}):map(function(p2)
		local characterScreenPosition = p2.characterScreenPosition
		local containerPositon = p2.containerPositon

		if characterScreenPosition and containerPositon then
			return (UDim2.fromOffset(
				characterScreenPosition.X - containerPositon.X,
				characterScreenPosition.Y - containerPositon.Y
			))
		end

		return UDim2.fromScale(0.5, 0.5)
	end)

	function self.absolutePositionChanged(p2)
		self.updateContainerPosition(p2.AbsolutePosition)
	end

	function self.renderStepped()
		self:updateSpinnerPosition()
	end
end

function extended:shouldRender()
	return self.props.ppeEmoteLoading or self.props.layeredClothingLoading or not self.props.hasAvatarData
end

function extended:render()
	if not self:shouldRender() then
		return nil
	end

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[Roact.Change.AbsolutePosition] = self.absolutePositionChanged,
			[Roact.Ref] = self.containerRef
		},
		{
			LoadingSpinner = Roact.createElement(loading, {
				size = iconSize.Large,
				Position = self.positionBinding,
				AnchorPoint = Vector2.new(0.5, 0.5)
			}),
			RenderSteppedConnection = Roact.createElement(externalEventConnection, {
				event = RunService.RenderStepped,
				callback = self.renderStepped
			})
		}
	)
end

function extended:didMount()
	if self.containerRef:getValue() then
		self.absolutePositionChanged(self.containerRef:getValue())
	end

	self:updateSpinnerPosition()
end

function extended:updateSpinnerPosition()
	if not (self.props.currentCharacter and self.props.hasAvatarData) then
		return
	end

	local boundingBox, v5 = self.props.currentCharacter:GetBoundingBox()

	local worldToScreenPoint = Workspace.CurrentCamera:WorldToScreenPoint(boundingBox.Position)
	self.updateCharacterScreenPosition(worldToScreenPoint)
end

function extended:didUpdate(data)
	local v5 = self.props.layeredClothingLoading and not data.layeredClothingLoading
	local v6 = self.props.currentCharacter ~= data.currentCharacter
	local v7 = self.props.ppeEmoteLoading and not data.ppeEmoteLoading

	if v5 or v6 or v7 then
		self:updateSpinnerPosition()
	end
end

local function mapStateToProps(p2, p3)
	local v5 = p2.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.ppeEmoteLoadingCount > 0

	local v6 = {
		currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter,
		layeredClothingLoading = 0,
		hasAvatarData = 0,
		ppeEmoteLoading = 0
	}

	local v7 = if not fFlagAXUseSignalsForApplyingLayeredClothing then p2.AvatarExperience.AvatarScene.Character.ApplyingLayeredClothing else nil
	v6.layeredClothingLoading = v7

	v6.hasAvatarData = p2.AvatarExperience.AvatarEditor.HasAvatarData
	v6.ppeEmoteLoading = v5
	return v6
end

local v5 = RoactRodux.connect(mapStateToProps, nil)(extended)

local function AvatarLoadingSpinnerWithSignals(p2)
	local v6 = useSignalState(getApplyingLayeredClothingStore(false).getApplyingLayeredClothing)
	return React.createElement(v5, Cryo.Dictionary.union(p2, {
		layeredClothingLoading = v6
	}))
end

if fFlagAXUseSignalsForApplyingLayeredClothing then
	return React.memo(AvatarLoadingSpinnerWithSignals)
end

return v5
