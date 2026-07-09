local Parent = script:FindFirstAncestor("AppDebug").Parent
local React = require(Parent.React)
local t1 = {
	displayMode = "hidden",
	showClassName = true,
	showPosition = false,
	filterPattern = nil,
	tooltipOpacity = 0.9,
	highlightOnHover = true
}
local v4 = React.createContext(nil)

return {
	TagAnnotationContext = v4,
	TagAnnotationProvider = function(t2: {[any]: any}) -- line: 51
		-- upvalues: React (copy), t1 (copy), v4 (copy)
		local v7, v8 = React.useState(t1)
		local v9 = React.useCallback(function(s1: string, p1) -- line: 56
			-- upvalues: v8 (copy)
			v8(function(p2) -- line: 57
				-- upvalues: s1 (copy), p1 (copy)
				local v18 = table.clone(p2)

				v18[s1] = p1

				return v18
			end)
		end, {})
		local v10 = React.useCallback(function(s2: string) -- line: 64
			-- upvalues: v9 (copy)
			v9("displayMode", s2)
		end, { v9 })
		local v11 = React.useCallback(function(s3: string?) -- line: 68
			-- upvalues: v9 (copy)
			v9("filterPattern", s3)
		end, { v9 })
		local t3 = {
			config = v7,
			setDisplayMode = v10,
			setFilterPattern = v11
		}

		return React.createElement(v4.Provider, {
			value = t3
		}, t2.children)
	end,
	useTagAnnotationContext = function() -- line: 43
		-- upvalues: React (copy), v4 (copy)
		local v5 = React.useContext(v4)

		if not v5 then
			error("useTagAnnotationContext must be used within a TagAnnotationProvider")
		end

		return v5
	end
}
