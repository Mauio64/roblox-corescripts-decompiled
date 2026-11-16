local ContextActionService = game:GetService("ContextActionService")

local parent = script:FindFirstAncestor("TextChannelWindow").Parent
local React = require(parent.React)

require(script.Parent.SelectionInputs)

local count = 0

local function useCoreActionBind(data)
	local contextActionService = data.contextActionService or ContextActionService

	local ref = React.useRef(nil)

	if ref.current == nil then
		count += 1
		ref.current = count
	end

	local v = data.actionNamePrefix .. "_" .. tostring(ref.current)

	local enabled = data.enabled
	local active = data.active
	local inputs = data.inputs
	local onAction = data.onAction
	local shouldBind = data.shouldBind
	local rebindSignal = data.rebindSignal

	React.useEffect(function()
		if not (enabled and active) then
			return
		end

		local function handler(_: string, p)
			return onAction(p)
		end

		local connection = nil

		if shouldBind then
			local function refresh() -- 1 equivalent call inferred from this helper
				if shouldBind() then
					contextActionService:BindCoreAction(v, handler, false, table.unpack(inputs))
				else
					contextActionService:UnbindCoreAction(v)
				end
			end

			refresh() -- inferred equivalent call

			if rebindSignal then
				connection = rebindSignal:Connect(refresh)
			end
		else
			contextActionService:BindCoreAction(v, handler, false, table.unpack(inputs))
		end

		return function()
			if connection then
				connection:Disconnect()
			end

			contextActionService:UnbindCoreAction(v)
		end
	end, { enabled, active, inputs, onAction, shouldBind, rebindSignal, contextActionService, v })
end

return useCoreActionBind
