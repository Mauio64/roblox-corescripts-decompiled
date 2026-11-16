local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local PeopleService = require(parent.PeopleService)
local SignalsReact = require(parent.SignalsReact)

local Constants = require(PeopleReactView.Constants)

local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local useSignalState = SignalsReact.useSignalState

local function PlatformNameSection(p)
	local v = useTokens()

	local v2 = React.useMemo(function()
		return PeopleService.getService("PeopleUtility")
	end, {})

	local v3 = React.useMemo(function()
		return PeopleService.getService("PeopleListStore")
	end, {})

	local v4 = React.useMemo(function()
		return v3.getPlatformName(p.UserId)
	end, { p.UserId })

	local v5 = React.useMemo(function()
		return v3.getPlatformProfileId(p.UserId)
	end, { p.UserId })

	local text = useSignalState(v4)
	local v6 = useSignalState(v5)

	local selectable = React.useMemo(function()
		return v2.canShowPlatformProfile(v6)
	end, { v6 })

	local onActivated = React.useCallback(function()
		v2.showPlatformProfile(v6)
	end, { v6 })

	local ref = React.useRef(nil)

	local ref2 = React.useCallback(function(p2)
		ref.current = p2

		if p2 and selectable then
			p2.NextSelectionLeft = p2
			p2.NextSelectionRight = nil
		end
	end, { selectable })
	local v7

	if text then
		if type(text) == "string" then
			v7 = string.len(text) > 0
		else
			v7 = false
		end
	else
		v7 = text
	end

	if v7 then
		return React.createElement(
			View,
			{ tag = "row gap-xsmall align-y-center auto-x size-0-full", LayoutOrder = -1 },
			{
				PlatformIconContainer = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 1
				}, {
					PlatformIcon = React.createElement("ImageLabel", {
						Image = Constants.PEOPLEPAGE.PERSON_ROW.PLATFORM_LOGO_IMAGE,
						Size = UDim2.fromOffset(v.Size.Size_900, v.Size.Size_900),
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						ImageColor3 = v.Color.Content.Default.Color3
					})
				}),
				PlatformNameButton = React.createElement(Button, {
					onActivated = onActivated,
					text = text,
					variant = ButtonVariant.Text,
					size = ButtonSize.Small,
					isDisabled = not selectable,
					Selectable = selectable,
					LayoutOrder = 2,
					ref = ref2
				})
			}
		)
	end

	return nil
end

return PlatformNameSection
