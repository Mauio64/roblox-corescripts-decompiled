local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local v13 = Roact.PureComponent:extend("AvatarLoadingSpinner")

v13.validateProps = t.interface({
	currentCharacter = t.optional(t.instanceIsA("Model")),
	layeredClothingLoading = t.boolean,
	hasAvatarData = t.boolean,
	ppeEmoteLoading = t.optional(t.boolean)
})

function v13.init(p1) -- line: 39
	-- upvalues: Roact (copy)
	p1.containerRef = Roact.createRef()

	local v16, v17 = Roact.createBinding(nil)

	p1.characterScreenPosition = v16
	p1.updateCharacterScreenPosition = v17

	local v18, v19 = Roact.createBinding(nil)

	p1.containerPositon = v18
	p1.updateContainerPosition = v19
	p1.positionBinding = Roact.joinBindings({
		characterScreenPosition = p1.characterScreenPosition,
		containerPositon = p1.containerPositon
	}):map(function(p2) -- line: 50
		local characterScreenPosition = p2.characterScreenPosition
		local containerPositon = p2.containerPositon

		if not characterScreenPosition or not containerPositon then
			return UDim2.fromScale(0.5, 0.5)
		end

		return (UDim2.fromOffset(characterScreenPosition.X - containerPositon.X, characterScreenPosition.Y - containerPositon.Y))
	end)

	function p1.absolutePositionChanged(p3) -- line: 68
		-- upvalues: p1 (copy)
		p1.updateContainerPosition(p3.AbsolutePosition)
	end
	function p1.renderStepped() -- line: 72
		-- upvalues: p1 (copy)
		p1:updateSpinnerPosition()
	end
end
function v13.shouldRender(p4) -- line: 77
	return p4.props.ppeEmoteLoading or (p4.props.layeredClothingLoading or not p4.props.hasAvatarData)
end
function v13.render(p5) -- line: 81
	-- upvalues: Roact (copy), Loading (copy), IconSize (copy), ExternalEventConnection (copy), RunService (copy)
	if p5:shouldRender() then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[Roact.Change.AbsolutePosition] = p5.absolutePositionChanged,
			[Roact.Ref] = p5.containerRef
		}, {
			LoadingSpinner = Roact.createElement(Loading, {
				size = IconSize.Large,
				Position = p5.positionBinding,
				AnchorPoint = Vector2.new(0.5, 0.5)
			}),
			RenderSteppedConnection = Roact.createElement(ExternalEventConnection, {
				event = RunService.RenderStepped,
				callback = p5.renderStepped
			})
		})
	end

	return nil
end
function v13.didMount(p6) -- line: 105
	if p6.containerRef:getValue() then
		p6.absolutePositionChanged(p6.containerRef:getValue())
	end

	p6:updateSpinnerPosition()
end
function v13.updateSpinnerPosition(p7) -- line: 113
	-- upvalues: Workspace (copy)
	if not p7.props.currentCharacter or not p7.props.hasAvatarData then
		return
	end

	local v24, _ = p7.props.currentCharacter:GetBoundingBox()
	local v26 = Workspace.CurrentCamera:WorldToScreenPoint(v24.Position)

	p7.updateCharacterScreenPosition(v26)
end
function v13.didUpdate(p8, p9) -- line: 124
	local v29 = p8.props.layeredClothingLoading and not p9.layeredClothingLoading
	local v30 = p8.props.currentCharacter ~= p9.currentCharacter
	local v31 = p8.props.ppeEmoteLoading and not p9.ppeEmoteLoading

	if v29 or (v30 or v31) then
		p8:updateSpinnerPosition()
	end
end

local function mapStateToProps(p10, _) -- line: 134
	local v34 = p10.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.ppeEmoteLoadingCount > 0

	return {
		currentCharacter = p10.AvatarExperience.AvatarScene.Character.CurrentCharacter,
		layeredClothingLoading = p10.AvatarExperience.AvatarScene.Character.ApplyingLayeredClothing,
		hasAvatarData = p10.AvatarExperience.AvatarEditor.HasAvatarData,
		ppeEmoteLoading = v34
	}
end

return (RoactRodux.connect(mapStateToProps, nil)(v13))
