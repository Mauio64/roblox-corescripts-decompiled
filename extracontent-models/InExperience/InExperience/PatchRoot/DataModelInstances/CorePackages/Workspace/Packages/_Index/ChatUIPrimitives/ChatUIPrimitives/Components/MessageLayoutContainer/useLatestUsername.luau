local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useLatestUsername(callback, callback2, current)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	local ref3 = React.useRef(current)
	ref3.current = current

	React.useEffect(function()
		if callback2 == nil then
			return nil
		end

		local function onLatestIdChanged(p)
			local v = callback(p)
			local current4

			if v == nil then
				current4 = false
			else
				current4 = v == callback2(p)
			end

			local current2 = ref2.current
			ref2.current = current4

			local current3 = ref3.current

			if current3 == nil then
				return
			end

			if current4 and not current2 then
				current3(ref.current)
			end
		end
		local effect = Signals.createEffect(onLatestIdChanged)
		return function()
			effect()

			if ref2.current then
				ref2.current = false
				local current2 = ref3.current

				if current2 ~= nil then
					current2(nil)
				end
			end
		end
	end, { callback, callback2 })

	local ref4 = React.useRef(current)
	React.useEffect(function()
		local current2 = ref4.current
		ref4.current = current

		if current2 == current or not ref2.current then
			return
		end

		if current2 ~= nil then
			current2(nil)
		end

		if current ~= nil then
			current(ref.current)
		end
	end, { current })

	return (React.useCallback(function(current2)
		ref.current = current2
		local current3 = ref3.current

		if ref2.current and current3 ~= nil then
			current3(current2)
		end
	end, {}))
end

return useLatestUsername
