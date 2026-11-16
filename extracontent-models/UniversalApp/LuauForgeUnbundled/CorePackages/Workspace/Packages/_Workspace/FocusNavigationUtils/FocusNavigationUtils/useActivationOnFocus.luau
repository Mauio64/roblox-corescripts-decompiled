local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation")

local PendingActivationOnFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/PendingActivationOnFocus")

local v5 = nil
local v6 = nil

local function useActivationOnFocus(p2, p3, current, current2, current3, p4, duration)
	local v7 = current ~= nil
	local v8 = p4 == true

	if duration == nil or not (duration > 0) then
		duration = nil
	end

	local ref = React.useRef(current)
	local ref2 = React.useRef(current2)
	local ref3 = React.useRef(current3)
	ref.current = current
	ref2.current = current2
	ref3.current = current3

	local v9 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	React.useEffect(function()
		if not (p2 and v7 and v9) then
			return function() end
		end

		local v10 = {}

		local function getIdentity()
			local current4 = ref3.current

			if current4 then
				return (current4())
			end

			return nil
		end

		local function isAlreadyActivated(p5, p6)
			local v11 = not v8

			if v11 then
				v11 = v5 == p5 and v6 == p6
			end

			return v11
		end

		local function isOwnPendingActivation(): boolean
			local v11 = PendingActivationOnFocus.get()
			return v11 ~= nil and v11.owner == v10
		end

		local function commitActivation(p5, p6)
			if not v8 then
				v5 = p5
				v6 = p6
			end

			local current4 = ref.current

			if current4 then
				current4()
			end
		end

		local v11 = v9.focusedGuiObject:subscribe(function(p5)
			local current4 = p3.current
			local current5 = ref2.current

			if current5 then
				current4 = current5(current4)
			end

			if current4 == nil or p5 ~= current4 then
				local v12 = PendingActivationOnFocus.get()
				local v13 = not (v12 == nil) and v12.owner == v10

				if v13 then
					if p5 == nil then
						PendingActivationOnFocus.cancel()
					else
						local v14 = PendingActivationOnFocus.get()
						task.defer(function()
							if PendingActivationOnFocus.get() == v14 then
								PendingActivationOnFocus.flush()
							end
						end)
					end
				end
			else
				PendingActivationOnFocus.cancel()
				local v12

				if not v8 then
					local current6 = ref3.current

					if current6 then
						v12 = current6()
					end
				end

				local v13 = not v8

				if v13 then
					v13 = v5 == current4 and v6 == v12
				end

				if v13 then
					return
				end

				if duration == nil then
					if not v8 then
						v5 = current4
						v6 = v12
					end

					local current6 = ref.current

					if current6 then
						current6()
					end
				else
					local function activate()
						local current6 = ref3.current
						local v14 = if current6 then current6() else nil

						local v15 = current4
						local v16 = not v8

						if v16 then
							v16 = v5 == v15 and v6 == v14
						end

						if v16 then
							return nil
						end

						local v17 = current4

						if not v8 then
							v5 = v17
							v6 = v14
						end

						local current7 = ref.current

						if current7 then
							current7()
						end

						return v14
					end

					PendingActivationOnFocus.set({
						owner = v10,
						thread = task.delay(duration, function()
							PendingActivationOnFocus.set(nil)
							local current6 = ref3.current
							local v14 = if current6 then current6() else nil

							local v15 = current4
							local v16 = not v8

							if v16 then
								v16 = v5 == v15 and v6 == v14
							end

							if v16 then
								return
							end

							local v17 = current4

							if not v8 then
								v5 = v17
								v6 = v14
							end

							local current7 = ref.current

							if current7 then
								current7()
							end
						end),
						activate = activate
					})
				end
			end
		end)

		return function()
			v11:unsubscribe()
			local v12 = PendingActivationOnFocus.get()
			local v13 = not (v12 == nil) and v12.owner == v10

			if v13 then
				PendingActivationOnFocus.cancel()
			end
		end
	end, { p2, v7, v8, duration, v9, p3 })
end

return useActivationOnFocus
