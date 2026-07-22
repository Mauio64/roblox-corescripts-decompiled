local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local CoreGui = require(Foundation.Utility.Wrappers).Services.CoreGui
local GuiService = require(Foundation.Utility.Wrappers).Services.GuiService
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local useRefCache = require(FoundationParent.ReactUtils).useRefCache
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local Cursor = require(script.Parent.Cursors.Cursor)
local CursorComponent = require(script.Parent.CursorComponent)
local CursorContext = require(script.Parent.CursorContext)

require(Foundation.Enums.CursorType)

local KeyUtilities = require(script.Parent.KeyUtilities)

require(Foundation.Enums.ColorMode)
require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)

local function CursorProvider(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), useRefCache (copy), useTokens (copy), KeyUtilities (copy), Dash (copy), Cursor (copy), CursorComponent (copy), isPluginSecurity (copy), CoreGui (copy), GuiService (copy), CursorContext (copy)
	local v16, v17 = React.useState({})
	local v18 = React.useRef(nil)
	local v19, v20 = React.useState(nil)
	local v21 = useRefCache()
	local v22 = useTokens()
	local v23 = React.useMemo(function() -- line: 35
		-- upvalues: v21 (copy), v17 (copy), KeyUtilities (copy), v22 (copy), Dash (copy)
		return {
			refCache = v21,
			setMountedCursors = v17,
			getCursor = function(p1) -- line: 39
				-- upvalues: KeyUtilities (copy), v22 (copy), v17 (copy), Dash (copy), v21 (copy)
				local v40 = KeyUtilities.mapCursorToKey(p1, v22)

				v17(function(p2) -- line: 42
					-- upvalues: v40 (copy), Dash (copy)
					if p2[v40] == nil then
						return Dash.union(p2, {
							[v40] = true
						})
					end

					return p2
				end)

				return v21[v40]
			end
		}
	end, {
		v21,
		v17,
		v22
	})

	React.useEffect(function() -- line: 93
		-- upvalues: v18 (copy), isPluginSecurity (copy), CoreGui (copy), GuiService (copy), v20 (copy)
		if v18.current == nil or not game:IsAncestorOf(v18.current) then
			return
		end

		local v35 = isPluginSecurity() and v18.current:IsDescendantOf(CoreGui)

		local function setUpSelectionImageObjectConnection() -- line: 100
			-- upvalues: v35 (copy), GuiService (copy), v20 (copy)
			if v35 then
				return GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 105
					-- upvalues: GuiService (copy), v20 (copy)
					if GuiService.SelectedCoreObject == nil then
						v20(nil)

						return
					end

					v20(GuiService.SelectedCoreObject.SelectionImageObject)
				end)
			end

			return GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 113
				-- upvalues: GuiService (copy), v20 (copy)
				if GuiService.SelectedObject == nil then
					v20(nil)

					return
				end

				v20(GuiService.SelectedObject.SelectionImageObject)
			end)
		end

		local u37 = setUpSelectionImageObjectConnection()
		local connection = v18.current.AncestryChanged:Connect(function() -- line: 124
			-- upvalues: u37 (ref), setUpSelectionImageObjectConnection (copy)
			u37:Disconnect()
			u37 = setUpSelectionImageObjectConnection()
		end)

		return function() -- line: 134
			-- upvalues: u37 (ref), connection (copy)
			u37:Disconnect()
			connection:Disconnect()
		end
	end, {})

	return React.createElement(CursorContext.Provider, {
		value = v23
	}, {
		Children = React.createElement(React.Fragment, {}, t1.children),
		FoundationCursorContainer = React.createElement("Frame", {
			Visible = false,
			Size = UDim2.new(0, 0, 0, 0),
			ref = v18
		}, ((function() -- line: 56
			-- upvalues: v16 (copy), v21 (copy), v19 (copy), KeyUtilities (copy), React (copy), Cursor (copy), CursorComponent (copy)
			local t2 = {}

			for v25, _ in v16 do
				local v27 = v21[v25] ~= nil and (v19 ~= nil and v21[v25].current == v19)
				local parts = string.split(v25, " ")

				if #parts == 2 then
					local v29, v30 = KeyUtilities.decodeCursorTypeKey(parts)

					t2[v25] = React.createElement(Cursor, {
						ref = v21[v25],
						isVisible = v27,
						cursorType = v29,
						colorMode = v30
					})
				else
					local v31, v32, v33, v34 = KeyUtilities.decodeKey(parts)

					t2[v25] = React.createElement(CursorComponent, {
						ref = v21[v25],
						isVisible = v27,
						cornerRadius = v31,
						offset = v32,
						borderWidth = v33,
						colorMode = v34
					})
				end
			end

			return t2
		end)()))
	})
end

return CursorProvider
