local module = require("@luauforge/deferred/gzp")
local module2 = require("@luauforge/deferred/gzq")

local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local buttonSize = module2.Enums.ButtonSize
local fillBehavior = module2.Enums.FillBehavior
local iconName = module2.Enums.IconName

local module3 = require("@luauforge/deferred/gzt")
local authButtonClick = module3.Events.authButtonClick
local eventStreamConstants = module3.EventStreamConstants

local useDispatch = require("@luauforge/deferred/gzx").Hooks.RoactRodux.useDispatch

local module4 = require("@luauforge/deferred/gzy")

local function VpcContinueButton(props)
	local v5 = useDispatch()
	local networking = props.networking
	local localUserId = props.localUserId
	local refreshUserAccess = props.refreshUserAccess
	local state, setState = module.useState(false)

	local function refreshAccess()
		if refreshUserAccess ~= nil then
			v5(refreshUserAccess(networking)):catch(function()
				setState(false)
			end)
		end
	end

	local function onContinue()
		authButtonClick(
			eventStreamConstants.Context.PlatformRestrictedPage,
			eventStreamConstants.Button.Continue
		)

		if state then
			return
		end

		props.openVpcWizard(function(p2, items)
			if p2 == "Granted" then
				setState(true)

				if refreshUserAccess ~= nil then
					v5(refreshUserAccess(networking)):catch(function()
						setState(false)
					end)
				end
			else
				local v6 = false

				if typeof(items) == "table" then
					for k, item in items do
						if item == "Success" then
							v6 = true
							break
						end
					end
				end

				if v6 or p2 == "Pending" then
					setState(true)
				end
			end
		end)
	end

	module.useEffect(function()
		local v6 = tonumber(localUserId)

		if v6 == nil or v6 <= 0 then
			return
		end

		local v7 = false
		module4(networking, v6):andThen(function(p2)
			if not v7 and p2 then
				setState(true)
			end
		end)
		return function()
			v7 = true
		end
	end, { localUserId, networking })

	local createElement = module.createElement
	local v8 = if state then props.pendingText else props.text
	local v9 = if state then buttonVariant.Standard else buttonVariant.Emphasis
	local v7 = {
		text = v8,
		variant = v9,
		size = buttonSize.Large,
		fillBehavior = fillBehavior.Fill,
		width = UDim.new(1, 0),
		isDisabled = state,
		isLoading = false,
		icon = 0,
		onActivated = 0,
		testId = "platform-locked-continue-button",
		LayoutOrder = 0
	}

	local v10 = if state then iconName.Clock else nil
	v7.icon = v10
	v7.onActivated = onContinue

	v7.LayoutOrder = props.LayoutOrder
	return createElement(button, v7)
end

return VpcContinueButton
