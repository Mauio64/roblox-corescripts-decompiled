local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LoadableImage = UIBlox.App.Loading.LoadableImage

local parent = script.Parent.Parent.Parent

local PerformSetFavorite = require(parent.Thunks.PerformSetFavorite)
local SignalSetFavoritePermissionDenied = require(parent.Thunks.SignalSetFavoritePermissionDenied)

local defineFastFlag = game:DefineFastFlag("CloseFavoritePromptWithB", false)

local extended = Roact.PureComponent:extend("SetFavoritePrompt")

extended.validateProps = t.strictInterface({
	itemId = t.integer,
	itemType = t.enum(Enum.AvatarItemType),
	itemName = t.string,
	shouldFavorite = t.boolean,
	screenSize = t.Vector2,
	performSetFavorite = t.callback,
	signalSetFavoritePermissionDenied = t.callback
})

function extended:init()
	function self.renderAlertMiddleContent()
		local image = "rbxthumb://type=" .. (self.props.itemType == Enum.AvatarItemType.Asset and "Asset" or self.props.itemType == Enum.AvatarItemType.Bundle and "BundleThumbnail" or nil) .. "&id=" .. self.props.itemId .. "&w=150&h=150"

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

	if defineFastFlag then
		self.menuKey = "favorite_prompt_" .. self.props.itemId

		GuiService:SetMenuIsOpen(true, self.menuKey)
		ContextActionService:BindCoreAction(self.menuKey, function(_, p, _)
			if p ~= Enum.UserInputState.End then
				return Enum.ContextActionResult.Pass
			end

			self.props.signalSetFavoritePermissionDenied()
			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
	end
end

function extended.willUnmount(p)
	if defineFastFlag then
		GuiService:SetMenuIsOpen(false, p.menuKey)
		ContextActionService:UnbindCoreAction(p.menuKey)
	end
end

function extended.render(p)
	local title, bodyText

	if p.props.shouldFavorite then
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.FavouriteItemPromptTitle")
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.FavouriteItemPromptText", {
			RBX_NAME = p.props.itemName
		})
	else
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UnfavouriteItemPromptTitle")
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UnfavouriteItemPromptText", {
			RBX_NAME = p.props.itemName
		})
	end

	return Roact.createElement(InteractiveAlert, {
		title = title,
		bodyText = bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = p.props.signalSetFavoritePermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.FavouriteItemPromptNo")
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p.props.performSetFavorite,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.FavouriteItemPromptYes"),
						isDelayedInput = true,
						enableInputDelayed = true,
						delayInputSeconds = 3
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
		itemId = p.promptInfo.itemId,
		itemType = p.promptInfo.itemType,
		itemName = p.promptInfo.itemName,
		shouldFavorite = p.promptInfo.shouldFavorite,
		screenSize = p.screenSize
	}
end

local function mapDispatchToProps(callback)
	return {
		performSetFavorite = function()
			return callback(PerformSetFavorite)
		end,
		signalSetFavoritePermissionDenied = function()
			return callback(SignalSetFavoritePermissionDenied)
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
