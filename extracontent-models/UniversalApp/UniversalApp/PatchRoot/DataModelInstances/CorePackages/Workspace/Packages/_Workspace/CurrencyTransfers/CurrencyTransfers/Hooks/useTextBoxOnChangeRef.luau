local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local GetFFlagCurrencyTransferFixTextBoxInput = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixTextBoxInput)

return function(p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 18
	-- upvalues: React (copy), GetFFlagCurrencyTransferFixTextBoxInput (copy)
	local v7 = React.useRef(nil)
	local v8 = React.useRef(false)

	return React.useCallback(function(p3) -- line: 29
		-- upvalues: v7 (copy), GetFFlagCurrencyTransferFixTextBoxInput (copy), v8 (copy), p1 (copy), p2 (copy)
		if v7.current then
			for _, v in ipairs(v7.current) do
				v:Disconnect()
			end

			v7.current = nil
		end

		if p3 then
			local t1 = {}

			table.insert(t1, p3:GetPropertyChangedSignal("Text"):Connect(function() -- line: 41
				-- upvalues: p3 (copy), GetFFlagCurrencyTransferFixTextBoxInput (copy), v8 (copy), p1 (copy)
				local p3Text = p3.Text
				local v14 = p3Text:gsub("%D", "")

				if v14 ~= p3Text then
					p3.Text = v14
				end

				if GetFFlagCurrencyTransferFixTextBoxInput() and v8.current and v14 == "" then
					return
				end

				p1((tonumber(v14)))
			end))

			if p2 then
				table.insert(t1, p3.Focused:Connect(function() -- line: 60
					-- upvalues: GetFFlagCurrencyTransferFixTextBoxInput (copy), p3 (copy), v8 (copy), p2 (copy)
					if GetFFlagCurrencyTransferFixTextBoxInput() then
						p3.CursorPosition = #p3.Text + 1
						v8.current = true
						task.delay(0.1, function() -- line: 67
							-- upvalues: v8 (copy)
							v8.current = false
						end)
					end

					p2(true, false)
				end))
				table.insert(t1, p3.FocusLost:Connect(function(enterPressed: boolean) -- line: 77
					-- upvalues: p2 (copy)
					p2(false, enterPressed)
				end))
			end

			v7.current = t1
		end
	end, {
		p1,
		p2
	})
end
