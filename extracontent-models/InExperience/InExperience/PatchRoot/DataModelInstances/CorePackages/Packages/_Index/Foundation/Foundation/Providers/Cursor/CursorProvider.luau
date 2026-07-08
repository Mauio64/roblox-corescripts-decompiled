local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Flags = require(Foundation.Utility.Flags)
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

local function CursorProvider(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), useRefCache (copy), useTokens (copy), KeyUtilities (copy), Dash (copy), Cursor (copy), CursorComponent (copy), Flags (copy), isPluginSecurity (copy), CoreGui (copy), GuiService (copy), CursorContext (copy)
	local v17, v18 = React.useState({})
	local v19 = React.useRef(nil)
	local v20, v21 = React.useState(nil)
	local v22 = useRefCache()
	local v23 = useTokens()
	local v24 = React.useMemo(function() -- line: 36
		-- upvalues: v22 (copy), v18 (copy), KeyUtilities (copy), v23 (copy), Dash (copy)
		return {
			refCache = v22,
			setMountedCursors = v18,
			getCursor = function(p1) -- line: 40
				-- upvalues: KeyUtilities (copy), v23 (copy), v18 (copy), Dash (copy), v22 (copy)
				local v41 = KeyUtilities.mapCursorToKey(p1, v23)

				v18(function(p2) -- line: 43
					-- upvalues: v41 (copy), Dash (copy)
					if p2[v41] == nil then
						return Dash.union(p2, {
							[v41] = true
						})
					end

					return p2
				end)

				return v22[v41]
			end
		}
	end, {
		v22,
		v18,
		v23
	})

	React.useEffect(function() -- line: 94
		-- upvalues: v19 (copy), Flags (copy), isPluginSecurity (copy), CoreGui (copy), GuiService (copy), v21 (copy)
		if v19.current == nil or if not Flags.FoundationAllowMockDataModel then not v19.current:IsDescendantOf(game) else not game:IsAncestorOf(v19.current) then
			return
		end

		local v36 = isPluginSecurity() and v19.current:IsDescendantOf(CoreGui)

		local function setUpSelectionImageObjectConnection() -- line: 108
			-- upvalues: v36 (copy), GuiService (copy), v21 (copy)
			if v36 then
				return GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 113
					-- upvalues: GuiService (copy), v21 (copy)
					if GuiService.SelectedCoreObject == nil then
						v21(nil)

						return
					end

					v21(GuiService.SelectedCoreObject.SelectionImageObject)
				end)
			end

			return GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 121
				-- upvalues: GuiService (copy), v21 (copy)
				if GuiService.SelectedObject == nil then
					v21(nil)

					return
				end

				v21(GuiService.SelectedObject.SelectionImageObject)
			end)
		end

		local u38 = setUpSelectionImageObjectConnection()
		local connection = v19.current.AncestryChanged:Connect(function() -- line: 132
			-- upvalues: u38 (ref), setUpSelectionImageObjectConnection (copy)
			u38:Disconnect()
			u38 = setUpSelectionImageObjectConnection()
		end)

		return function() -- line: 142
			-- upvalues: u38 (ref), connection (copy)
			u38:Disconnect()
			connection:Disconnect()
		end
	end, {})

	return React.createElement(CursorContext.Provider, {
		value = v24
	}, {
		Children = React.createElement(React.Fragment, {}, t1.children),
		FoundationCursorContainer = React.createElement("Frame", {
			Visible = false,
			Size = UDim2.new(0, 0, 0, 0),
			ref = v19
		}, ((function() -- line: 57
			-- upvalues: v17 (copy), v22 (copy), v20 (copy), KeyUtilities (copy), React (copy), Cursor (copy), CursorComponent (copy)
			local t2 = {}

			for v26, _ in v17 do
				local v28 = v22[v26] ~= nil and (v20 ~= nil and v22[v26].current == v20)
				local parts = string.split(v26, " ")

				if #parts == 2 then
					local v30, v31 = KeyUtilities.decodeCursorTypeKey(parts)

					t2[v26] = React.createElement(Cursor, {
						ref = v22[v26],
						isVisible = v28,
						cursorType = v30,
						colorMode = v31
					})
				else
					local v32, v33, v34, v35 = KeyUtilities.decodeKey(parts)

					t2[v26] = React.createElement(CursorComponent, {
						ref = v22[v26],
						isVisible = v28,
						cornerRadius = v32,
						offset = v33,
						borderWidth = v34,
						colorMode = v35
					})
				end
			end

			return t2
		end)()))
	})
end

return CursorProvider
