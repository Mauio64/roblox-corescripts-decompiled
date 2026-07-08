local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local UserProfiles = require(PeopleReactViewParent.UserProfiles)
local RobloxAppHooks = require(PeopleReactViewParent.RobloxAppHooks)
local RobloxAppEnums = require(PeopleReactViewParent.RobloxAppEnums)
local Avatar = Foundation.Avatar
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber
local useInExperienceCombinedName = require(PeopleReactView.Hooks.useInExperienceCombinedName)
local PlatformName = require(PeopleReactView.Components.Buttons.PlatformName)
local PersonButtonRow = require(PeopleReactView.Components.List.PersonButtonRow)
local formatUsername = UserProfiles.Formatters.formatUsername
local FFlagEnableBlackbirdCheck = require(PeopleReactViewParent.SharedFlags).FFlagEnableBlackbirdCheck
local v26 = game:DefineFastFlag("PlayerListRefactorUsernameFormatting", false)
local GetFFlagAddPeoplePageCardLayout = PeopleService.getService("Flags").GetFFlagAddPeoplePageCardLayout

local function PersonRow(t1: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), React (copy), PeopleService (copy), GetFFlagAddPeoplePageCardLayout (copy), useInExperienceCombinedName (copy), useSignalBinding (copy), Avatar (copy), InputSize (copy), FoundationText (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), v26 (copy), formatUsername (copy), PersonButtonRow (copy), PlatformName (copy)
	local v30 = useTokens()
	local v31 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local v32 = nil

	if FFlagEnableBlackbirdCheck then
		v32 = useIsRobloxSubscriber((tostring(t1.person.UserId)))
	end

	local v33 = React.useRef(nil)
	local v34 = React.useCallback(function(p1) -- line: 58
		-- upvalues: PeopleService (copy), t1 (copy), v33 (copy)
		PeopleService.getService("FocusNavigationService").registerFrame(p1, t1.person.UserId)
		v33.current = p1
	end, { t1.person.UserId })
	local v35

	if GetFFlagAddPeoplePageCardLayout() then
		v35 = useInExperienceCombinedName(t1.person.UserId, t1.person.DisplayName)
	else
		local v36 = React.useMemo(function() -- line: 68
			-- upvalues: PeopleService (copy)
			return PeopleService.getService("PeopleListStore")
		end, {})
		local v37 = React.useMemo(function() -- line: 72
			-- upvalues: v36 (copy), t1 (copy)
			return v36.getProfile(t1.person.UserId)
		end, { t1.person.UserId })

		v35 = useSignalBinding(v37):map(function(p2) -- line: 78
			-- upvalues: t1 (copy)
			if p2 and string.len(p2) > 0 then
				return p2
			end

			return t1.person.DisplayName
		end)
	end

	local t2 = {
		Color3 = v30.Color.Shift.Shift_300.Color3,
		Transparency = v30.Color.Shift.Shift_300.Transparency
	}
	local v39 = React.createElement(Avatar, {
		LayoutOrder = 1,
		userId = t1.person.UserId,
		size = InputSize.Large,
		backgroundStyle = t2
	})
	local v40 = React.createElement(FoundationText, {
		tag = "text-label-medium auto-xy text-align-x-left text-truncate-end",
		LayoutOrder = 1,
		Text = v35,
		textStyle = {
			Color3 = v30.Color.Content.Default.Color3
		}
	})

	return React.createElement(View, {
		tag = {
			["padding-small row bg-surface-200 radius-medium"] = true,
			["size-full-2600 gap-medium"] = v31,
			["size-full-1500"] = not v31
		},
		LayoutOrder = t1.layoutOrder,
		ref = v34
	}, {
		PortraitAvatar = v31 and v39 or nil,
		RowContent = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["gap-medium size-full align-y-center text-no-wrap"] = true,
				["flex-between row"] = not v31,
				col = v31
			}
		}, {
			LeftContent = React.createElement(View, {
				LayoutOrder = 1,
				tag = {
					["row gap-medium align-y-center text-no-wrap"] = true,
					["size-full-0 auto-y"] = v31,
					["size-0-full auto-x"] = not v31
				}
			}, {
				Avatar = not v31 and v39 or nil,
				NameContainer = React.createElement(View, {
					tag = "col gap-small auto-xy flex-evenly",
					LayoutOrder = 2
				}, {
					DisplayName = if not FFlagEnableBlackbirdCheck or not v32 then v40 else React.createElement(View, {
						tag = "row gap-xsmall auto-xy align-y-center",
						LayoutOrder = 1
					}, {
						Name = v40,
						SubscriptionBadge = React.createElement(Icon, {
							LayoutOrder = 2,
							name = IconName.RobloxPlus,
							size = IconSize.Small,
							style = {
								Color3 = v30.Color.Content.Default.Color3
							}
						})
					}),
					UserName = React.createElement(FoundationText, {
						tag = "text-caption-small auto-xy text-align-x-left content-muted text-truncate-end",
						LayoutOrder = 2,
						Text = if not v26 then "@" .. t1.person.Name else formatUsername(t1.person.Name)
					})
				})
			}),
			RightContent = React.createElement(View, {
				tag = "row auto-x size-0-1000 gap-medium",
				LayoutOrder = 2
			}, {
				PersonButtonRow = React.createElement(PersonButtonRow, {
					userId = t1.person.UserId,
					index = t1.layoutOrder,
					personRowRef = v33
				}),
				PlatformNameSection = React.createElement(PlatformName, {
					UserId = t1.person.UserId
				})
			})
		})
	})
end

return PersonRow
