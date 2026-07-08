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
local ParentParent = script.Parent.Parent.Parent
local SignalDeleteOutfitPermissionDenied = require(ParentParent.Thunks.SignalDeleteOutfitPermissionDenied)
local PerformDeleteOutfit = require(ParentParent.Thunks.PerformDeleteOutfit)
local AvatarEditorPromptsPolicy = require(ParentParent.AvatarEditorPromptsPolicy)
local v15 = Roact.PureComponent:extend("DeleteOutfitPrompt")

v15.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	outfitId = t.integer,
	outfitName = t.string,
	performDeleteOutfit = t.callback,
	signalDeleteOutfitPermissionDenied = t.callback,
	showCustomOutfitNames = t.boolean
})

function v15.init(p1) -- line: 43
	-- upvalues: Roact (copy), LoadableImage (copy)
	function p1.renderAlertMiddleContent() -- line: 44
		-- upvalues: p1 (copy), Roact (copy), LoadableImage (copy)
		local v26 = "rbxthumb://type=Outfit&id=" .. p1.props.outfitId .. "&w=150&h=150"

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 150)
		}, {
			Thumnail = Roact.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				useShimmerAnimationWhileLoading = true,
				showFailedStateWhenLoadingFailed = true,
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.fromOffset(150, 150),
				Image = v26
			})
		})
	end
end
function v15.render(p2) -- line: 64
	-- upvalues: RobloxTranslator (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local v21 = if not p2.props.showCustomOutfitNames then RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptTextNoName") else RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptText", {
		RBX_NAME = p2.props.outfitName
	})

	return Roact.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptTitle"),
		bodyText = v21,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p2.props.signalDeleteOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptNo")
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p2.props.performDeleteOutfit,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DeleteOutfitPromptYes")
					}
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = p2.props.screenSize,
		middleContent = p2.renderAlertMiddleContent
	})
end

local function mapStateToProps(p3) -- line: 103
	return {
		screenSize = p3.screenSize,
		outfitId = p3.promptInfo.outfitId,
		outfitName = p3.promptInfo.outfitName
	}
end
local function mapDispatchToProps(p4) -- line: 111
	-- upvalues: SignalDeleteOutfitPermissionDenied (copy), PerformDeleteOutfit (copy)
	return {
		signalDeleteOutfitPermissionDenied = function() -- line: 113
			-- upvalues: p4 (copy), SignalDeleteOutfitPermissionDenied (copy)
			return p4(SignalDeleteOutfitPermissionDenied)
		end,
		performDeleteOutfit = function() -- line: 117
			-- upvalues: p4 (copy), PerformDeleteOutfit (copy)
			return p4(PerformDeleteOutfit)
		end
	}
end

local v18 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v15)

return (AvatarEditorPromptsPolicy.connect(function(p5, _) -- line: 125
	return {
		showCustomOutfitNames = p5.getCustomOutfitNames()
	}
end)(v18))
