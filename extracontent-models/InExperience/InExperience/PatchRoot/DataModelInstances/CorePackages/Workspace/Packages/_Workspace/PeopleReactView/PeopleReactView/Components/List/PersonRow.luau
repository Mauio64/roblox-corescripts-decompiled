local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent
local FFlagPeopleTabUseProfileFrameThumbnail = require(PeopleReactView.Flags.FFlagPeopleTabUseProfileFrameThumbnail)

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local PeopleService = require(parent.PeopleService)
local SignalsReact = require(parent.SignalsReact)
local UserProfiles = require(parent.UserProfiles)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local Avatar = Foundation.Avatar
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local useInExperienceCombinedName = require(PeopleReactView.Hooks.useInExperienceCombinedName)

local PlatformName = require(PeopleReactView.Components.Buttons.PlatformName)
local PersonButtonRow = require(PeopleReactView.Components.List.PersonButtonRow)
local PeoplePageLayoutContext = require(PeopleReactView.PeoplePageLayoutContext)

local formatUsername = UserProfiles.Formatters.formatUsername

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagPeopleListButtonOverflow = require(PeopleReactView.Flags.FFlagPeopleListButtonOverflow)
local defineFastFlag = game:DefineFastFlag("PlayerListRefactorUsernameFormatting", false)
local getFFlagAddPeoplePageCardLayout = PeopleService.getService("Flags").GetFFlagAddPeoplePageCardLayout

local function PersonRow(p)
	local v = useTokens()
	local v2 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local v3 = React.useContext(PeoplePageLayoutContext)
	local v4 = v2 or FFlagPeopleListButtonOverflow and v3.isCompact
	local v5

	if FFlagEnableBlackbirdCheck then
		v5 = useIsRobloxSubscriber((tostring(p.person.UserId)))
	end

	local ref = React.useRef(nil)

	local ref2 = React.useCallback(function(current)
		PeopleService.getService("FocusNavigationService").registerFrame(current, p.person.UserId)
		ref.current = current
	end, { p.person.UserId })
	local text

	if getFFlagAddPeoplePageCardLayout() then
		text = useInExperienceCombinedName(p.person.UserId, p.person.DisplayName)
	else
		local v6 = React.useMemo(function()
			return PeopleService.getService("PeopleListStore")
		end, {})

		text = useSignalBinding((React.useMemo(function()
			return v6.getProfile(p.person.UserId)
		end, { p.person.UserId }))):map(function(value)
			if value and string.len(value) > 0 then
				return value
			end

			return p.person.DisplayName
		end)
	end

	local backgroundStyle = {
		Color3 = v.Color.Shift.Shift_300.Color3,
		Transparency = v.Color.Shift.Shift_300.Transparency
	}

	local element = React.createElement(Avatar, {
		userId = p.person.UserId,
		size = InputSize.Large,
		backgroundStyle = backgroundStyle,
		includeProfileFrame = FFlagPeopleTabUseProfileFrameThumbnail,
		LayoutOrder = 1
	})

	local v6 = React.createElement(Text, {
		Text = text,
		textStyle = { Color3 = v.Color.Content.Default.Color3 },
		tag = "text-label-medium auto-xy text-align-x-left text-truncate-end",
		LayoutOrder = 1
	})

	local createElement = React.createElement
	local v7 = {
		tag = {
			["padding-small row bg-surface-200 radius-medium"] = true,
			["size-full-2600 gap-medium"] = v4,
			["size-full-1500"] = not v4
		},
		LayoutOrder = p.layoutOrder,
		ref = ref2
	}

	local v8 = {
		PortraitAvatar = v4 and element or nil,
		RowContent = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	if v4 or not element then
		element = nil
	end

	local createElement4 = React.createElement

	if FFlagEnableBlackbirdCheck and v5 then
		v6 = React.createElement(View, {
			tag = "row gap-xsmall auto-xy align-y-center",
			LayoutOrder = 1
		}, {
			Name = v6,
			SubscriptionBadge = React.createElement(Icon, {
				name = IconName.RobloxPlus,
				size = IconSize.Small,
				style = { Color3 = v.Color.Content.Default.Color3 },
				LayoutOrder = 2
			})
		})
	end

	local createElement5 = React.createElement
	local text2

	if defineFastFlag then
		text2 = formatUsername(p.person.Name)
	else
		text2 = "@" .. p.person.Name
	end

	v8.RowContent = createElement2(View, {
		tag = {
			["gap-medium size-full align-y-center text-no-wrap"] = true,
			["flex-between row"] = not v4,
			col = v4
		},
		LayoutOrder = 2
	}, {
		LeftContent = createElement3(View, {
			tag = {
				["row gap-medium align-y-center text-no-wrap"] = true,
				["size-full-0 auto-y"] = v4,
				["size-0-full auto-x"] = not v4
			},
			LayoutOrder = 1
		}, {
			Avatar = element,
			NameContainer = createElement4(View, {
				tag = "col gap-small auto-xy flex-evenly",
				LayoutOrder = 2
			}, {
				DisplayName = v6,
				UserName = createElement5(Text, {
					Text = text2,
					tag = "text-caption-small auto-xy text-align-x-left content-muted text-truncate-end",
					LayoutOrder = 2
				})
			})
		}),
		RightContent = React.createElement(View, {
			tag = "row auto-x size-0-1000 gap-medium",
			LayoutOrder = 2
		}, {
			PersonButtonRow = React.createElement(PersonButtonRow, {
				userId = p.person.UserId,
				index = p.layoutOrder,
				personRowRef = ref
			}),
			PlatformNameSection = React.createElement(PlatformName, { UserId = p.person.UserId })
		})
	})
	return createElement(View, v7, v8)
end

return PersonRow
