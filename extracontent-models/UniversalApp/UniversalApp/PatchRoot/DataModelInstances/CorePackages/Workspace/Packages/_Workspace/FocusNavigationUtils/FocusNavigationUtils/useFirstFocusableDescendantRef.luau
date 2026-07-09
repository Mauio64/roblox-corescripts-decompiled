local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)
local getFirstFocusableDescendant = require(script.Parent.getFirstFocusableDescendant)

local function safeDisconnect(p1) -- line: 6
	if p1 then
		p1:Disconnect()
	end
end
local function useFirstFocusableDescendantRef(p2) -- line: 23
	-- upvalues: React (copy), getFirstFocusableDescendant (copy)
	local v8 = React.useRef(nil)

	React.useEffect(function() -- line: 26
		-- upvalues: getFirstFocusableDescendant (copy), v8 (copy), p2 (copy)
		local connection = nil
		local connection2 = nil
		local connection3 = nil

		local function updateFirstFocusable(p3) -- line: 31
			-- upvalues: connection (ref), connection3 (ref), getFirstFocusableDescendant (copy), updateFirstFocusable (copy), v8 (copy)
			local v14 = connection

			if v14 then
				v14:Disconnect()
			end

			local v15 = connection3

			if v15 then
				v15:Disconnect()
			end

			local v16 = getFirstFocusableDescendant(p3)

			if v16 then
				connection = v16:GetPropertyChangedSignal("Selectable"):Connect(function() -- line: 38
					-- upvalues: updateFirstFocusable (copy), p3 (copy)
					updateFirstFocusable(p3)
				end)
				connection3 = v16.AncestryChanged:Connect(function() -- line: 42
					-- upvalues: updateFirstFocusable (copy), p3 (copy)
					updateFirstFocusable(p3)
				end)
			end

			v8.current = v16
		end

		if p2 then
			updateFirstFocusable(p2)
			connection2 = p2.DescendantAdded:Connect(function() -- line: 51
				-- upvalues: updateFirstFocusable (copy), p2 (copy)
				updateFirstFocusable(p2)
			end)
		else
			v8.current = nil
		end

		return function() -- line: 58
			-- upvalues: connection (ref), connection2 (ref), connection3 (ref)
			local v17 = connection

			if v17 then
				v17:Disconnect()
			end

			local v18 = connection2

			if v18 then
				v18:Disconnect()
			end

			local v19 = connection3

			if v19 then
				v19:Disconnect()
			end
		end
	end, { p2 })

	return v8
end

return useFirstFocusableDescendantRef
