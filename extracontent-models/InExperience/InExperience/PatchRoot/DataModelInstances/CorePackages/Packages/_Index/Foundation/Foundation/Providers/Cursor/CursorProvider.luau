local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Wrappers = require(Foundation.Utility.Wrappers)
local CoreGui = Wrappers.Services.CoreGui
local Wrappers2 = require(Foundation.Utility.Wrappers)
local GuiService = Wrappers2.Services.GuiService

local Dash = require(parent.Dash)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useRefCache = ReactUtils.useRefCache
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)

local Cursor = require(script.Parent.Cursors.Cursor)
local CursorComponent = require(script.Parent.CursorComponent)
local CursorContext = require(script.Parent.CursorContext)
require(Foundation.Enums.CursorType)
local KeyUtilities = require(script.Parent.KeyUtilities)

require(Foundation.Enums.ColorNamespace)

require(Foundation.Components.Types)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function CursorProvider(p)
	local state, setState = React.useState({})
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(nil)
	local refCache = useRefCache()
	local v = useTokens()

	local v2 = React.useMemo(function()
		return {
			refCache = refCache,
			setMountedCursors = setState,
			getCursor = function(p2)
				local mapCursorToKey = KeyUtilities.mapCursorToKey(p2, v)

				setState(function(p3)
					if p3[mapCursorToKey] == nil then
						return Dash.union(p3, { [mapCursorToKey] = true })
					end

					return p3
				end)

				return refCache[mapCursorToKey]
			end
		}
	end, { refCache, setState, v })

	local function fn()
		local children = {}

		for k, _ in state do
			local isVisible

			if refCache[k] == nil or state2 == nil then
				isVisible = false
			else
				isVisible = refCache[k].current == state2
			end

			local v3 = string.split(k, " ")

			if #v3 == 2 then
				local decodeCursorTypeKey, colorNamespace = KeyUtilities.decodeCursorTypeKey(v3)

				children[k] = React.createElement(Cursor, {
					ref = refCache[k],
					isVisible = isVisible,
					cursorType = decodeCursorTypeKey,
					colorNamespace = colorNamespace
				})
			else
				local decodeKey, offset, borderWidth, colorNamespace = KeyUtilities.decodeKey(v3)

				children[k] = React.createElement(CursorComponent, {
					ref = refCache[k],
					isVisible = isVisible,
					cornerRadius = decodeKey,
					offset = offset,
					borderWidth = borderWidth,
					colorNamespace = colorNamespace
				})
			end
		end

		return children
	end

	React.useEffect(function()
		if ref.current == nil or not game:IsAncestorOf(ref.current) then
			return
		end

		local v3 = isPluginSecurity() and ref.current:IsDescendantOf(CoreGui)

		local function setUpSelectionImageObjectConnection()
			if v3 then
				return GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
					if GuiService.SelectedCoreObject == nil then
						setState2(nil)
					else
						setState2(GuiService.SelectedCoreObject.SelectionImageObject)
					end
				end)
			end

			return GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
				if GuiService.SelectedObject == nil then
					setState2(nil)
				else
					setState2(GuiService.SelectedObject.SelectionImageObject)
				end
			end)
		end

		local connection = setUpSelectionImageObjectConnection()
		local ancestryChangedConnection = ref.current.AncestryChanged:Connect(function()
			connection:Disconnect()
			connection = setUpSelectionImageObjectConnection()
		end)

		return function()
			connection:Disconnect()
			ancestryChangedConnection:Disconnect()
		end
	end, {})

	return React.createElement(CursorContext.Provider, { value = v2 }, {
		Children = React.createElement(React.Fragment, {}, p.children),
		FoundationCursorContainer = React.createElement(
			"Frame",
			{ Size = UDim2.new(0, 0, 0, 0), Visible = false, ref = ref },
			fn()
		)
	})
end

return CursorProvider
