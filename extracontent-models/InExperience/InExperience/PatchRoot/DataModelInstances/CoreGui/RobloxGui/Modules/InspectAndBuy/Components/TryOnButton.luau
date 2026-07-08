local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)
local Constants = require(ParentParent.Constants)
local SetTryingOnInfo = require(ParentParent.Actions.SetTryingOnInfo)
local TryOnItem = require(ParentParent.Thunks.TryOnItem)
local getSelectionImageObjectRounded = require(ParentParent.getSelectionImageObjectRounded)
local TryOn = require(script.Parent.Common.ControllerShortcutKeycodes).TryOn
local v14 = Roact.PureComponent:extend("TryOnButton")

function v14.init(p1) -- line: 22
	-- upvalues: getSelectionImageObjectRounded (copy), ContextActionService (copy), TryOn (copy)
	p1.selectedImage = getSelectionImageObjectRounded()
	ContextActionService:BindCoreAction("TryOnGamepadShortcut", function(_, p3, _) -- line: 25
		-- upvalues: p1 (copy)
		if p3 == Enum.UserInputState.End then
			p1:activateButton()

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, TryOn)
end
function v14.activateButton(p5) -- line: 34
	-- upvalues: Constants (copy)
	if not p5.props.showTryOn then
		return
	end

	local assetInfo = p5.props.assetInfo
	local tryOnItem = p5.props.tryOnItem
	local takeOffItem = p5.props.takeOffItem
	local tryingOn = p5.props.tryingOnInfo.tryingOn
	local partOfBundleAndOffsale = p5.props.partOfBundleAndOffsale
	local bundleId = p5.props.bundleId

	if not assetInfo or (not p5.props.localPlayerModel or (Constants.LayeredAssetTypes[assetInfo.assetTypeId] == nil or p5.props.localPlayerModel.Humanoid.RigType ~= Enum.HumanoidRigType.R6)) then
		if tryingOn then
			takeOffItem()

			return
		end

		tryOnItem(true, assetInfo.assetId, assetInfo.assetTypeId, partOfBundleAndOffsale, bundleId)
	end
end
function v14.willUnmount(_) -- line: 61
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("TryOnGamepadShortcut")
end
function v14.render(p7) -- line: 65
	-- upvalues: Constants (copy), Roact (copy), Colors (copy), RobloxTranslator (copy), AppFonts (copy)
	local tryingOn = p7.props.tryingOnInfo.tryingOn
	local showTryOn = p7.props.showTryOn
	local locale = p7.props.locale
	local assetInfo = p7.props.assetInfo
	local tryOnButtonRef = p7.props.tryOnButtonRef
	local v30 = not tryingOn and "InGame.InspectMenu.Action.TryOn" or "InGame.InspectMenu.Action.TakeOff"
	local v31 = assetInfo and (p7.props.localPlayerModel and (Constants.LayeredAssetTypes[assetInfo.assetTypeId] ~= nil and p7.props.localPlayerModel.Humanoid.RigType == Enum.HumanoidRigType.R6))

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Image = "rbxasset://textures/ui/InspectMenu/Button_outline.png",
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0.5, -32, 0, 44),
		Visible = showTryOn,
		ImageTransparency = not v31 and 0 or 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(5, 5, 120, 20)
	}, {
		SelectionGainedImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Visible = false,
			Image = "rbxasset://textures/ui/InspectMenu/Button_white.png",
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = Colors.Pumice
		}),
		TryOnTextKey = Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = RobloxTranslator:FormatByKeyForLocale(v30, locale),
			Font = AppFonts.default:getDefault(),
			TextSize = 16,
			TextColor3 = Colors.White,
			TextTransparency = not v31 and 0 or 0.5,
			SelectionImageObject = p7.selectedImage,
			ZIndex = 2,
			[Roact.Event.SelectionGained] = function(p8) -- line: 114
				-- upvalues: Colors (copy)
				p8.Parent.SelectionGainedImage.Visible = true
				p8.TextColor3 = Colors.Carbon
			end,
			[Roact.Event.SelectionLost] = function(p9) -- line: 118
				-- upvalues: Colors (copy)
				p9.Parent.SelectionGainedImage.Visible = false
				p9.TextColor3 = Colors.White
			end,
			[Roact.Ref] = tryOnButtonRef,
			[Roact.Event.Activated] = function() -- line: 123
				-- upvalues: p7 (copy)
				p7:activateButton()
			end
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p10, _) -- line: 130
	local assetId = p10.detailsInformation.assetId

	return {
		locale = p10.locale,
		view = p10.view,
		assetInfo = p10.assets[assetId],
		bundleInfo = p10.bundles,
		tryingOnInfo = p10.tryingOnInfo
	}
end, function(p12) -- line: 140
	-- upvalues: TryOnItem (copy), SetTryingOnInfo (copy)
	return {
		tryOnItem = function(p13, p14, p15, p16, p17) -- line: 142
			-- upvalues: p12 (copy), TryOnItem (copy)
			p12(TryOnItem(p13, p14, p15, p16, p17))
		end,
		takeOffItem = function() -- line: 145
			-- upvalues: p12 (copy), SetTryingOnInfo (copy)
			p12(SetTryingOnInfo(false, nil, nil))
		end
	}
end)(v14)
