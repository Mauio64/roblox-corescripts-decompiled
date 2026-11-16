local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local GetFFlagCurrencyTransferFixTextBoxInput = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFixTextBoxInput")

return function(callback, callback2)
	local ref = React.useRef(nil)

	local ref2 = React.useRef(false)

	return React.useCallback(function(instance)
		if ref.current then
			for i, connection in ipairs(ref.current) do
				connection:Disconnect()
			end

			ref.current = nil
		end

		if instance then
			local connections = {}
			table.insert(connections, instance:GetPropertyChangedSignal("Text"):Connect(function()
				local text = instance.Text
				local v5 = text:gsub("%D", "")

				if v5 ~= text then
					instance.Text = v5
				end

				if GetFFlagCurrencyTransferFixTextBoxInput() and ref2.current and v5 == "" then
					return
				end

				callback((tonumber(v5)))
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

				table.insert(connections, instance.FocusLost:Connect(function(p2)
					callback2(false, p2)
				end))
			end

			ref.current = connections
		end
	end, { callback, callback2 })
end
