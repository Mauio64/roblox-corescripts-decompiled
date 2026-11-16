local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local PendingActivationOnFocus = require(script.Parent.PendingActivationOnFocus)

local v = nil
local v2 = nil

local function useActivationOnFocus(flag: boolean, p, current, current2, current3, flag2: boolean?, duration: number?)
	local v3 = current ~= nil
	local v4 = flag2 == true

	if duration == nil or not (duration > 0) then
		duration = nil
	end

	local ref = React.useRef(current)
	local ref2 = React.useRef(current2)
	local ref3 = React.useRef(current3)
	ref.current = current
	ref2.current = current2
	ref3.current = current3

	local v5 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	React.useEffect(function()
		if not (flag and v3 and v5) then
			return function() end
		end

		local owner = {}

		local function getIdentity() -- 2 equivalent calls inferred from this helper
			local current4 = ref3.current

			if current4 then
				return (current4())
			end

			return nil
		end

		local function isAlreadyActivated(current4, p2) -- 2 equivalent calls inferred from this helper
			local v6 = not v4

			if v6 then
				if v == current4 then
					return v2 == p2
				end

				return false
			end

			return v6
		end

		local function isOwnPendingActivation(): boolean -- 2 equivalent calls inferred from this helper
			local v6 = PendingActivationOnFocus.get()
			return v6 ~= nil and v6.owner == owner
		end

		local function commitActivation(current4, p2) -- 2 equivalent calls inferred from this helper
			if not v4 then
				v = current4
				v2 = p2
			end

			local current5 = ref.current

			if current5 then
				current5()
			end
		end

		local v6 = v5.focusedGuiObject:subscribe(function(p2)
			local current4 = p.current
			local current5 = ref2.current

			if current5 then
				current4 = current5(current4)
			end

			if current4 == nil or p2 ~= current4 then
				if isOwnPendingActivation() then -- inferred equivalent call
					if p2 == nil then
						PendingActivationOnFocus.cancel()
					else
						local v6 = PendingActivationOnFocus.get()
						task.defer(function()
							if PendingActivationOnFocus.get() == v6 then
								PendingActivationOnFocus.flush()
							end
						end)
					end
				end
			else
				PendingActivationOnFocus.cancel()
				local v6

				if not v4 then
					v6 = getIdentity() -- inferred equivalent call
				end

				if isAlreadyActivated(current4, v6) then -- inferred equivalent call
					return
				end

				if duration == nil then
					commitActivation(current4, v6) -- inferred equivalent call
				else
					local function activate() -- 1 equivalent call inferred from this helper
						local identity = getIdentity() -- inferred equivalent call

						if isAlreadyActivated(current4, identity) then -- inferred equivalent call
							return nil
						end

						commitActivation(current4, identity) -- inferred equivalent call
						return identity
					end

					PendingActivationOnFocus.set({
						owner = owner,
						thread = task.delay(duration, function()
							PendingActivationOnFocus.set(nil)
							activate() -- inferred equivalent call
						end),
						activate = activate
					})
				end
			end
		end)

		return function()
			v6:unsubscribe()

			if isOwnPendingActivation() then -- inferred equivalent call
				PendingActivationOnFocus.cancel()
			end
		end
	end, { flag, v3, v4, duration, v5, p })
end

return useActivationOnFocus
