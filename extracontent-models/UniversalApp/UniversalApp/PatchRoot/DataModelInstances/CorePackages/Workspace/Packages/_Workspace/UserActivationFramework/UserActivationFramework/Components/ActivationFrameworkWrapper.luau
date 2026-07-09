local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)
local FullPageNavigationHeader = require(UserActivationFramework.Components.FullPageNavigationHeader)
local FullPageNavigationFooter = require(UserActivationFramework.Components.FullPageNavigationFooter)

require(UserActivationFramework.Components.ActivationFrameworkTokenMapper)
require(UserActivationFramework.Types)

local FullPageActivationFrameworkContext = require(UserActivationFramework.Context.FullPageActivationFrameworkContext)
local NavigationAction = require(UserActivationFramework.Enums.NavigationAction)
local useDesignTokens = require(UserActivationFrameworkParent.Style).useDesignTokens
local AuthAnalytics = require(UserActivationFrameworkParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authPageload = AuthAnalytics.Events.authPageload

require(UserActivationFramework.Enums.Namespace)

local useUpdateActivationWorkflowAndNavigate = require(UserActivationFramework.Hooks.useUpdateActivationWorkflowAndNavigate)

local function ActivationFrameworkWrapper(t1: {[any]: any}) -- line: 48
	-- upvalues: React (copy), FullPageActivationFrameworkContext (copy), useDesignTokens (copy), authPageload (copy), useUpdateActivationWorkflowAndNavigate (copy), authButtonClick (copy), EventStreamConstants (copy), NavigationAction (copy), FullPageNavigationHeader (copy), FullPageNavigationFooter (copy)
	local activationFrameworkState = React.useContext(FullPageActivationFrameworkContext).activationFrameworkState
	local v17, v18 = React.useState(0)
	local v19, v20 = React.useState(0)
	local v21, v22 = React.useState(0)
	local v23, v24 = React.useState(0)
	local v25, v26 = React.useState(0)
	local v27, v28 = React.useState(0)
	local v29, v30 = React.useState(0)
	local v31, v32 = React.useState(0)
	local ActivationFramework = useDesignTokens().LuaApps.ActivationFramework
	local v34 = not t1.shouldExpandMiddleContent

	React.useEffect(function() -- line: 68
		-- upvalues: authPageload (copy), t1 (copy), activationFrameworkState (copy)
		authPageload(t1.namespace, activationFrameworkState.currentState)
	end, {})

	local u35 = useUpdateActivationWorkflowAndNavigate(t1.navigation)
	local v36, v37 = React.useState({
		shouldShowBackButton = false,
		icon = "icons/actions/cycleLeft",
		onBack = function() -- line: 75
			-- upvalues: authButtonClick (copy), t1 (copy), EventStreamConstants (copy), activationFrameworkState (copy), u35 (ref), NavigationAction (copy)
			authButtonClick(t1.namespace, EventStreamConstants.Button.Back, activationFrameworkState.currentState)
			u35(NavigationAction.Back)
		end
	})
	local v38, v39 = React.useState({
		shouldShowSkipButton = false,
		skipButtonTextKey = "Authentication.SignUp.Label.Skip",
		onSkip = function() -- line: 80
			-- upvalues: authButtonClick (copy), t1 (copy), EventStreamConstants (copy), activationFrameworkState (copy), u35 (ref), NavigationAction (copy)
			authButtonClick(t1.namespace, EventStreamConstants.Button.Skip, activationFrameworkState.currentState)
			u35(NavigationAction.Skip)
		end
	})

	React.useEffect(function() -- line: 93
		-- upvalues: v36 (copy), v38 (copy), activationFrameworkState (copy), NavigationAction (copy), v37 (copy), v39 (copy)
		local v43 = table.clone(v36)
		local v44 = table.clone(v38)

		v44.shouldShowSkipButton = table.find(activationFrameworkState.availableActions, NavigationAction.Skip) ~= nil
		v43.shouldShowBackButton = false

		if table.find(activationFrameworkState.availableActions, NavigationAction.Back) then
			v43.shouldShowBackButton = true
			v43.icon = "icons/actions/cycleLeft"
		elseif table.find(activationFrameworkState.availableActions, NavigationAction.Close) then
			v43.shouldShowBackButton = true
			v43.icon = "icons/navigation/close"
		end

		v37(v43)
		v39(v44)
	end, { activationFrameworkState.availableActions })

	local verticalPaddingPx = ActivationFramework.verticalPaddingPx
	local verticalPaddingPx2 = ActivationFramework.verticalPaddingPx

	React.useLayoutEffect(function() -- line: 117
		-- upvalues: v21 (copy), ActivationFramework (copy), v26 (copy), v30 (copy)
		if v21 > 0 then
			local v45 = v21 - ActivationFramework.horizontalPaddingPx * 2

			v26(v45)
			v30(v45)
		end
	end, { v21 })
	React.useLayoutEffect(function() -- line: 127
		-- upvalues: v34 (copy), v17 (copy), v19 (copy), v23 (copy), v27 (copy), verticalPaddingPx (copy), verticalPaddingPx2 (copy), v32 (copy)
		if v34 and (v17 > 0 and v19 > 0 and v23 > 0 and v27 > 0) then
			local v46 = v23 - v17 - v19 - verticalPaddingPx - verticalPaddingPx2 - v27

			v32(v46)
		end
	end, {
		v17,
		v19,
		v23,
		v27
	})
	React.useLayoutEffect(function() -- line: 144
		-- upvalues: t1 (copy), v17 (copy), v19 (copy), v23 (copy), verticalPaddingPx (copy), verticalPaddingPx2 (copy), v31 (copy), v28 (copy)
		if t1.shouldExpandMiddleContent and (v17 > 0 and v19 > 0 and v23 > 0) then
			local v47 = v23 - v17 - v19 - verticalPaddingPx - verticalPaddingPx2 - v31

			v28(v47)
		end
	end, {
		v17,
		v19,
		v23,
		v31
	})

	local t2 = {
		primaryButton = t1.primaryButton,
		secondaryButton = t1.secondaryButton,
		shouldShowButtonDivider = t1.shouldShowButtonDivider,
		navigation = t1.navigation
	}

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = function(p1) -- line: 164
			-- upvalues: v22 (copy), v24 (copy)
			v22(p1.AbsoluteSize.X)
			v24(p1.AbsoluteSize.Y)
		end,
		BorderSizePixel = 0
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, ActivationFramework.verticalPaddingPx),
			PaddingTop = UDim.new(0, ActivationFramework.verticalPaddingPx),
			PaddingLeft = UDim.new(0, ActivationFramework.horizontalPaddingPx),
			PaddingRight = UDim.new(0, ActivationFramework.horizontalPaddingPx)
		}),
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		Header = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = function(p2) -- line: 187
				-- upvalues: v18 (copy)
				v18(p2.AbsoluteSize.Y)
			end,
			LayoutOrder = 1
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, ActivationFramework.headerTopPadding)
			}),
			HeaderContent = React.createElement(FullPageNavigationHeader, {
				skipProps = v38,
				backProps = v36,
				titleTextKey = t1.titleTextKey,
				bodyTextKey = t1.bodyTextKey,
				headingTextKey = t1.headingTextKey,
				ixpTitleTextKey = t1.ixpTitleTextKey,
				ixpBodyTextKey = t1.ixpBodyTextKey
			})
		}),
		Content = React.createElement("Frame", {
			Size = if not t1.shouldExpandMiddleContent then UDim2.new(0, v25, 0, 0) else UDim2.new(0, v25, 0, v27),
			AutomaticSize = if t1.shouldExpandMiddleContent then nil else Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			[React.Change.AbsoluteSize] = function(p3) -- line: 212
				-- upvalues: t1 (copy), v28 (copy)
				if not t1.shouldExpandMiddleContent then
					v28(p3.AbsoluteSize.Y)
				end
			end
		}, { t1.children }),
		Footer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			[React.Change.AbsoluteSize] = function(p4) -- line: 223
				-- upvalues: v20 (copy)
				v20(p4.AbsoluteSize.Y)
			end,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, ActivationFramework.footerTopPaddingPx)
			}),
			FooterContent = React.createElement(FullPageNavigationFooter, t2)
		}),
		SubFooterContent = if not t1.subFooterContent then nil else React.createElement("Frame", {
			Size = if not v34 then UDim2.new(0, v29, 0, 0) else UDim2.new(0, v29, 0, v31),
			AutomaticSize = if v34 then nil else Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			[React.Change.AbsoluteSize] = function(p5) -- line: 242
				-- upvalues: v34 (copy), v32 (copy)
				if not v34 then
					v32(p5.AbsoluteSize.Y)
				end
			end
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, ActivationFramework.subfooterTopPaddingPx),
				PaddingBottom = UDim.new(0, ActivationFramework.subfooterBottomPaddingPx)
			}),
			t1.subFooterContent
		})
	})
end

return ActivationFrameworkWrapper
