local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local parent = script.Parent.Parent
local Colors = require(parent.Colors)
local Constants = require(parent.Constants)
local SetTryingOnInfo = require(parent.Actions.SetTryingOnInfo)
local TryOnItem = require(parent.Thunks.TryOnItem)
local getSelectionImageObjectRounded = require(parent.getSelectionImageObjectRounded)

local ControllerShortcutKeycodes = require(script.Parent.Common.ControllerShortcutKeycodes)
local TryOn = ControllerShortcutKeycodes.TryOn

local extended = Roact.PureComponent:extend("TryOnButton")

function extended:init()
	self.selectedImage = getSelectionImageObjectRounded()

	ContextActionService:BindCoreAction("TryOnGamepadShortcut", function(_, p, _)
		if p ~= Enum.UserInputState.End then
			return Enum.ContextActionResult.Pass
		end

		self:activateButton()
		return Enum.ContextActionResult.Sink
	end, false, TryOn)
end

function extended:activateButton()
	if not self.props.showTryOn then
		return
	end

	local assetInfo = self.props.assetInfo
	local tryOnItem = self.props.tryOnItem
	local takeOffItem = self.props.takeOffItem
	local tryingOn = self.props.tryingOnInfo.tryingOn
	local partOfBundleAndOffsale = self.props.partOfBundleAndOffsale
	local bundleId = self.props.bundleId

	local v = assetInfo and self.props.localPlayerModel

	if v then
		if Constants.LayeredAssetTypes[assetInfo.assetTypeId] == nil then
			v = false
		else
			v = self.props.localPlayerModel.Humanoid.RigType == Enum.HumanoidRigType.R6
		end
	end

	if not v then
		if tryingOn then
			takeOffItem()
		else
			tryOnItem(true, assetInfo.assetId, assetInfo.assetTypeId, partOfBundleAndOffsale, bundleId)
		end
	end
end

function extended.willUnmount(_)
	ContextActionService:UnbindCoreAction("TryOnGamepadShortcut")
end

function extended:render()
	local tryingOn = self.props.tryingOnInfo.tryingOn
	local showTryOn = self.props.showTryOn
	local locale = self.props.locale
	local assetInfo = self.props.assetInfo
	local tryOnButtonRef = self.props.tryOnButtonRef

	local v = assetInfo and self.props.localPlayerModel

	if v then
		if Constants.LayeredAssetTypes[assetInfo.assetTypeId] == nil then
			v = false
		else
			v = self.props.localPlayerModel.Humanoid.RigType == Enum.HumanoidRigType.R6
		end
	end

	return Roact.createElement("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, -32, 0, 44),
		Visible = showTryOn,
		LayoutOrder = 2,
		Image = "rbxasset://textures/ui/InspectMenu/Button_outline.png",
		ImageTransparency = v and 0.5 or 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(5, 5, 120, 20)
	}, {
		SelectionGainedImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false,
			Image = "rbxasset://textures/ui/InspectMenu/Button_white.png",
			ImageColor3 = Colors.Pumice
		}),
		TryOnTextKey = Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = RobloxTranslator:FormatByKeyForLocale(
				tryingOn and "InGame.InspectMenu.Action.TakeOff" or "InGame.InspectMenu.Action.TryOn",
				locale
			),
			Font = AppFonts.default:getDefault(),
			TextSize = 16,
			TextColor3 = Colors.White,
			TextTransparency = v and 0.5 or 0,
			SelectionImageObject = self.selectedImage,
			ZIndex = 2,
			[Roact.Event.SelectionGained] = function(p)
				p.Parent.SelectionGainedImage.Visible = true
				p.TextColor3 = Colors.Carbon
			end,
			[Roact.Event.SelectionLost] = function(p)
				p.Parent.SelectionGainedImage.Visible = false
				p.TextColor3 = Colors.White
			end,
			[Roact.Ref] = tryOnButtonRef,
			[Roact.Event.Activated] = function()
				self:activateButton()
			end
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		locale = data.locale,
		view = data.view,
		assetInfo = data.assets[assetId],
		bundleInfo = data.bundles,
		tryingOnInfo = data.tryingOnInfo
	}
end, function(callback)
	return {
		tryOnItem = function(p, p2, p3, p4, p5)
			callback(TryOnItem(p, p2, p3, p4, p5))
		end,
		takeOffItem = function()
			callback(SetTryingOnInfo(false, nil, nil))
		end
	}
end)(extended)
