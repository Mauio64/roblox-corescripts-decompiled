local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Constants = require(PeopleReactView.Constants)
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local function PlatformNameSection(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), React (copy), PeopleService (copy), useSignalState (copy), View (copy), Constants (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local v16 = useTokens()
	local v17 = React.useMemo(function() -- line: 31
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleUtility")
	end, {})
	local v18 = React.useMemo(function() -- line: 35
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleListStore")
	end, {})
	local v19 = React.useMemo(function() -- line: 40
		-- upvalues: v18 (copy), t1 (copy)
		return v18.getPlatformName(t1.UserId)
	end, { t1.UserId })
	local v20 = React.useMemo(function() -- line: 44
		-- upvalues: v18 (copy), t1 (copy)
		return v18.getPlatformProfileId(t1.UserId)
	end, { t1.UserId })
	local v21 = useSignalState(v19)
	local v22 = useSignalState(v20)
	local v23 = React.useMemo(function() -- line: 52
		-- upvalues: v17 (copy), v22 (copy)
		return v17.canShowPlatformProfile(v22)
	end, { v22 })
	local v24 = React.useCallback(function() -- line: 57
		-- upvalues: v17 (copy), v22 (copy)
		v17.showPlatformProfile(v22)
	end, { v22 })
	local v25 = React.useRef(nil)
	local v26 = React.useCallback(function(p1) -- line: 63
		-- upvalues: v25 (copy), v23 (copy)
		v25.current = p1

		if p1 and v23 then
			p1.NextSelectionLeft = p1
			p1.NextSelectionRight = nil
		end
	end, { v23 })

	if not v21 or (type(v21) ~= "string" or not (string.len(v21) > 0)) then
		return nil
	end

	return React.createElement(View, {
		tag = "row gap-xsmall align-y-center auto-x size-0-full",
		LayoutOrder = -1
	}, {
		PlatformIconContainer = React.createElement(View, {
			tag = "auto-xy",
			LayoutOrder = 1
		}, {
			PlatformIcon = React.createElement("ImageLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Image = Constants.PEOPLEPAGE.PERSON_ROW.PLATFORM_LOGO_IMAGE,
				Size = UDim2.fromOffset(v16.Size.Size_900, v16.Size.Size_900),
				ImageColor3 = v16.Color.Content.Default.Color3
			})
		}),
		PlatformNameButton = React.createElement(Button, {
			LayoutOrder = 2,
			onActivated = v24,
			text = v21,
			variant = ButtonVariant.Text,
			size = ButtonSize.Small,
			isDisabled = not v23,
			Selectable = v23,
			ref = v26
		})
	})
end

return PlatformNameSection
