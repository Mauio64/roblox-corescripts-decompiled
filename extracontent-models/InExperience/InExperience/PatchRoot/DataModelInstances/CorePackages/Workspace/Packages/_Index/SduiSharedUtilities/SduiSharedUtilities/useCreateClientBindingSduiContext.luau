local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiErrors = SduiCoreSystem.SduiErrors
local useCollectionLayoutConfig = require(Parent.CollectionViews).useCollectionLayoutConfig
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore
local CollectionItemSize = require(Parent.CollectionViews).CollectionViewTypes.CollectionItemSize
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = SharedFlags.FFlagSduiEventDetailsSupport
local t1 = {
	numColumns = 3,
	fractionalItemAmount = 0,
	columnGap = 24,
	sideMargin = 24,
	verticalPadding = 16
}

local function useCreateClientBindingSduiContext(s1: string, p1, n1: number?, n2: number?, s2: string?, b1: boolean?, s3: string?) -- line: 44
	-- upvalues: FFlagLuaAppCompositionAlways (copy), useCollectionLayoutConfig (copy), React (copy), Signals (copy), t1 (copy), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), getSduiServiceDependenciesStore (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy)
	local v23 = s3 or s1
	local u24 = nil
	local u25 = nil

	if not FFlagLuaAppCompositionAlways then
		u24 = useCollectionLayoutConfig(p1, n1)
		u25 = React.useCallback(function(p2) -- line: 61
			-- upvalues: Signals (copy), b1 (copy), t1 (copy), u24 (ref), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), s1 (copy)
			return Signals.createComputed(function(p3) -- line: 62
				-- upvalues: b1 (copy), t1 (copy), u24 (ref), p2 (copy), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), s1 (copy)
				if b1 ~= false then
					return t1
				end

				if u24 then
					return (u24[p2] or u24[CollectionItemSize.Small])(p3)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.NoPageLayoutConfig, {
					message = `No page layout config available for { s1 }, returning default config`
				}, s1)

				return t1
			end)
		end, {
			u24,
			s1,
			b1
		})
	end

	return (React.useMemo(function() -- line: 89
		-- upvalues: getSduiServiceDependenciesStore (copy), s1 (copy), v23 (copy), u25 (ref), b1 (copy), n2 (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), s2 (copy)
		return {
			dependencies = getSduiServiceDependenciesStore().getDependencies(s1),
			appPage = s1,
			routeName = v23,
			getPageLayoutConfig = u25,
			appCompositionEnabled = b1 == nil or b1,
			dataUpdatedTimestamp = n2,
			configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else s2
		}
	end, {
		s1,
		v23,
		u25,
		n2,
		if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else s2,
		b1
	}))
end

return useCreateClientBindingSduiContext
