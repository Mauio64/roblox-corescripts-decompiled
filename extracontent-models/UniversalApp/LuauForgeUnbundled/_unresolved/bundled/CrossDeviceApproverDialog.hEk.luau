local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useModalFocus = require("@luauforge/bundled/fCJ").useModalFocus
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module = require("@luauforge/bundled/fsq")
local module2 = require("@luauforge/bundled/hEl")

local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local orientation = Foundation.Enums.Orientation

local function mapUrl(p2)
	return module.fromString("apis:auth-token-service" .. p2)()
end

local function CrossDeviceApproverDialog(props)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = useModalFocus()
	local v7 = props.phase == "confirm"
	local v8 = props.phase == "allowed"
	local v9 = props.pendingAction ~= nil
	local location = props.location or ""
	local v10 = useLocalization({
		allow = "Authentication.CrossDevice.Action.Allow",
		dontAllow = "Authentication.CrossDevice.Action.DontAllow",
		done = "Authentication.CrossDevice.Action.Done",
		confirmTitle = "Authentication.CrossDevice.Heading.RecognizeSignIn",
		allowedTitle = "Authentication.CrossDevice.Heading.SignInAllowed",
		deniedTitle = "Authentication.CrossDevice.Heading.SignInDenied",
		description = "Authentication.CrossDevice.Description.DenyIfNotYou"
	})

	local mapImagePath = props.mapImagePath or ""
	local v11 = v7 and module2 and mapImagePath ~= ""
	local large = v5.Padding.Large
	local state, setState = React.useState(0)
	local v12 = React.useCallback(function(p2)
		local x = p2.AbsoluteSize.X

		if x <= 0 then
			return
		end

		local v13 = (x + large * 2) / (4 / 3)

		if math.abs(v13 - state) > 0.5 then
			setState(v13)
		end
	end, { large, state })
	local v13

	if v7 then
		v13 = {
			{
				text = v10.allow,
				variant = buttonVariant.Standard,
				onActivated = props.onAllow,
				isDisabled = v9,
				isLoading = props.pendingAction == "allow"
			},
			{
				text = v10.dontAllow,
				variant = buttonVariant.Standard,
				onActivated = props.onDeny,
				isDisabled = v9,
				isLoading = props.pendingAction == "deny"
			}
		}
	else
		v13 = {
			{
				text = v10.done,
				variant = buttonVariant.Emphasis,
				onActivated = props.onDone
			}
		}
	end

	local v14 = if v7 then v10.confirmTitle elseif v8 then v10.allowedTitle else v10.deniedTitle

	local createElement = React.createElement
	local root = dialog.Root
	local v15 = {
		disablePortal = false,
		hasBackdrop = true,
		ref = v6,
		size = dialogSize.Small,
		testId = "CrossDeviceApproverDialog"
	}

	local createElement2 = React.createElement
	local view = Foundation.View
	local v16 = {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, state),
		onAbsoluteSizeChanged = v12,
		tag = "col",
		ZIndex = 1
	}
	local v17 = {
		Media = React.createElement(dialog.HeroMedia, {
			media = not v11 and "" or module.fromString("apis:auth-token-service" .. mapImagePath)(),
			height = UDim.new(1, 0),
			scaleType = Enum.ScaleType.Crop,
			backgroundStyle = v5.Color.Surface.Surface_0
		}),
		Overlay = 0
	}

	local createElement3 = React.createElement
	local createElement4 = React.createElement
	local view2 = Foundation.View
	local v21 = {
		Position = UDim2.fromOffset(-large, 0),
		Size = UDim2.new(1, large * 2, 1, 0),
		ZIndex = 2,
		backgroundStyle = { Color3 = Color3.new(1, 1, 1), Transparency = 1 },
		testId = "CrossDeviceApproverDialog--map-placeholder"
	}

	local v22 = {
		LocationMarker = React.createElement(
			Foundation.View,
			{
				ZIndex = 2,
				tag = "position-center-center anchor-bottom-center auto-xy",
				testId = "CrossDeviceApproverDialog--location-marker"
			},
			{
				Icon = React.createElement(Foundation.Icon, {
					name = iconName.LocationPin,
					size = iconSize.Large,
					variant = iconVariant.Filled,
					style = v5.Color.System.Emphasis
				})
			}
		),
		Credit = 0
	}

	local v23 = if v11 then React.createElement(Foundation.Text, {
		Text = "© OpenStreetMap",
		Position = UDim2.new(0, 8, 1, -8),
		ZIndex = 2,
		tag = "anchor-bottom-left auto-xy text-caption-small"
	}) else nil
	v22.Credit = v23
	v17.Overlay = createElement3("Folder", {}, {
		MapSlot = createElement4(view2, v21, v22)
	})
	local children = { Hero = createElement2(view, v16, v17), Heading = 0, Actions = 0 }

	local createElement5 = React.createElement
	local view3 = Foundation.View
	local v24 = {
		LayoutOrder = 2,
		padding = {
			top = UDim.new(0, v5.Padding.XXSmall)
		},
		tag = {
			["col size-full-0 auto-y"] = v7,
			["row align-y-center gap-large size-full-0 auto-y"] = not v7
		}
	}

	local createElement6 = React.createElement
	local view4 = Foundation.View
	local v28

	if not v7 then
		local createElement7 = React.createElement
		local icon = Foundation.Icon

		local v30 = if v8 then iconName.CircleCheck else iconName.CircleX
		local v29 = {
			LayoutOrder = 1,
			name = v30,
			size = iconSize.Large,
			style = 0,
			variant = 0
		}
		local v31 = if v8 then v5.Color.System.Success else v5.Color.System.Alert
		v29.style = v31
		v29.variant = iconVariant.Filled
		v28 = createElement7(icon, v29)
	end

	local v25 = {
		TitleRow = createElement6(
			view4,
			{ LayoutOrder = 1, tag = "row align-y-center gap-large size-full-0 auto-y" },
			{
				ResultIcon = v28,
				TitleGroup = React.createElement(
					Foundation.View,
					{ LayoutOrder = 2, tag = "col align-x-left size-full-0 auto-y" },
					{
						Title = React.createElement(dialog.Title, { text = v14 }),
						Location = React.createElement(Foundation.Text, {
							LayoutOrder = 2,
							Text = location,
							tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
						})
					}
				)
			}
		),
		Description = 0
	}

	local v29 = if v7 then React.createElement(Foundation.View, {
		LayoutOrder = 2,
		padding = {
			top = UDim.new(0, v5.Padding.XSmall + 1),
			bottom = UDim.new(0, v5.Padding.XSmall + 1)
		},
		tag = "size-full-0 auto-y"
	}, {
		Description = React.createElement(dialog.Text, { Text = v10.description })
	}) else nil
	v25.Description = v29
	children.Heading = createElement5(view3, v24, v25)

	children.Actions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = v13,
		orientation = orientation.Vertical
	})
	return createElement(root, v15, children)
end

return CrossDeviceApproverDialog
