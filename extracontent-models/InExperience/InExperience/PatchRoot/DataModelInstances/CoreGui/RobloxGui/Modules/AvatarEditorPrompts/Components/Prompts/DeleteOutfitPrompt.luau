local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LoadableImage = UIBlox.App.Loading.LoadableImage

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent.Parent.Parent

local SignalDeleteOutfitPermissionDenied = require(parent.Thunks.SignalDeleteOutfitPermissionDenied)
local PerformDeleteOutfit = require(parent.Thunks.PerformDeleteOutfit)

local AvatarEditorPromptsPolicy = require(parent.AvatarEditorPromptsPolicy)

local extended = Roact.PureComponent:extend("DeleteOutfitPrompt")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	outfitId = t.integer,
	outfitName = t.string,
	performDeleteOutfit = t.callback,
	signalDeleteOutfitPermissionDenied = t.callback,
	showCustomOutfitNames = t.boolean
})

function extended:init()
	function self.renderAlertMiddleContent()
		local image = "rbxthumb://type=Outfit&id=" .. self.props.outfitId .. "&w=150&h=150"

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 150)
		}, {
			Thumnail = Roact.createElement(LoadableImage, {
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.fromOffset(150, 150),
				BackgroundTransparency = 1,
				Image = image,
				useShimmerAnimationWhileLoading = true,
				showFailedStateWhenLoadingFailed = true
			})
		})
	end
end

function extended.render(p)
	local bodyText

	if p.props.showCustomOutfitNames then
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptText", {
			RBX_NAME = p.props.outfitName
		})
	else
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptTextNoName")
	end

	return Roact.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptTitle"),
		bodyText = bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = p.props.signalDeleteOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptNo")
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p.props.performDeleteOutfit,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptYes")
					},
					isDefaultChild = false
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = p.props.screenSize,
		middleContent = p.renderAlertMiddleContent,
		isMiddleContentFocusable = false
	})
end

local function mapStateToProps(p)
	return {
		screenSize = p.screenSize,
		outfitId = p.promptInfo.outfitId,
		outfitName = p.promptInfo.outfitName
	}
end

local function mapDispatchToProps(callback)
	return {
		signalDeleteOutfitPermissionDenied = function()
			return callback(SignalDeleteOutfitPermissionDenied)
		end,
		performDeleteOutfit = function()
			return callback(PerformDeleteOutfit)
		end
	}
end

local v = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

return (AvatarEditorPromptsPolicy.connect(function(p, _)
	return { showCustomOutfitNames = p.getCustomOutfitNames() }
end)(v))
