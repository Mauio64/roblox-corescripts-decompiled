local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local GetFFlagCurrencyTransferFixTextBoxInput = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixTextBoxInput)

return function(callback, callback2)
	local ref = React.useRef(nil)

	local ref2 = React.useRef(false)

	return React.useCallback(function(instance)
		if ref.current then
			for _, connection in ipairs(ref.current) do
				connection:Disconnect()
			end

			ref.current = nil
		end

		if instance then
			local connections = {}
			table.insert(connections, instance:GetPropertyChangedSignal("Text"):Connect(function()
				local text = instance.Text
				local text2 = text:gsub("%D", "")

				if text2 ~= text then
					instance.Text = text2
				end

				if GetFFlagCurrencyTransferFixTextBoxInput() and ref2.current and text2 == "" then
					return
				end

				callback((tonumber(text2)))
			end))

			if callback2 then
				table.insert(connections, instance.Focused:Connect(function()
					if GetFFlagCurrencyTransferFixTextBoxInput() then
						instance.CursorPosition = #instance.Text + 1
						ref2.current = true
						task.delay(0.1, function()
							ref2.current = false
						end)
					end

					callback2(true, false)
				end))

				table.insert(connections, instance.FocusLost:Connect(function(flag: boolean)
					callback2(false, flag)
				end))
			end

			ref.current = connections
		end
	end, { callback, callback2 })
end
