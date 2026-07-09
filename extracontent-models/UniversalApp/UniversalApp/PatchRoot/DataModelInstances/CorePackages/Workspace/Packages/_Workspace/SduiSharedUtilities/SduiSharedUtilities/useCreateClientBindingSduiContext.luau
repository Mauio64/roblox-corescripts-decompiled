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
local FFlagSduiChartsSupport = SharedFlags.FFlagSduiChartsSupport
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = SharedFlags.FFlagSduiEventDetailsSupport
local FFlagEnableSduiV2HomeInterleave = SharedFlags.FFlagEnableSduiV2HomeInterleave
local t1 = {
	numColumns = 3,
	fractionalItemAmount = 0,
	columnGap = 24,
	sideMargin = 24,
	verticalPadding = 16
}

local function useCreateClientBindingSduiContext(s1: string, p1, n1: number?, n2: number?, s2: string?, b1: boolean?, s3: string?) -- line: 46
	-- upvalues: FFlagLuaAppCompositionAlways (copy), FFlagEnableSduiV2HomeInterleave (copy), React (copy), Signals (copy), t1 (copy), useCollectionLayoutConfig (copy), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), getSduiServiceDependenciesStore (copy), FFlagSduiChartsSupport (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy)
	local v25 = s3 or s1
	local u26 = nil
	local u27 = nil

	if not FFlagLuaAppCompositionAlways then
		if not FFlagEnableSduiV2HomeInterleave then
			u27 = React.useCallback(function(_) -- line: 63
				-- upvalues: Signals (copy), t1 (copy)
				return Signals.createComputed(function(_) -- line: 64
					-- upvalues: t1 (copy)
					return t1
				end)
			end, {})
		else
			u26 = useCollectionLayoutConfig(p1, n1)
			u27 = React.useCallback(function(p4) -- line: 71
				-- upvalues: Signals (copy), FFlagEnableSduiV2HomeInterleave (copy), b1 (copy), t1 (copy), u26 (ref), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), s1 (copy)
				return Signals.createComputed(function(p5) -- line: 72
					-- upvalues: FFlagEnableSduiV2HomeInterleave (copy), b1 (copy), t1 (copy), u26 (ref), p4 (copy), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), s1 (copy)
					if FFlagEnableSduiV2HomeInterleave and b1 ~= false then
						return t1
					end

					if u26 then
						return (u26[p4] or u26[CollectionItemSize.Small])(p5)
					end

					SduiLogger.reportError(SduiErrors.SduiErrorType.NoPageLayoutConfig, {
						message = `No page layout config available for { s1 }, returning default config`
					}, s1)

					return t1
				end)
			end, {
				u26,
				s1,
				if not FFlagEnableSduiV2HomeInterleave then nil else b1
			})
		end
	end

	return (React.useMemo(function() -- line: 99
		-- upvalues: getSduiServiceDependenciesStore (copy), s1 (copy), v25 (copy), u27 (ref), FFlagEnableSduiV2HomeInterleave (copy), b1 (copy), FFlagSduiChartsSupport (copy), n2 (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy), s2 (copy)
		return {
			dependencies = getSduiServiceDependenciesStore().getDependencies(s1),
			appPage = s1,
			routeName = v25,
			getPageLayoutConfig = u27,
			appCompositionEnabled = not FFlagEnableSduiV2HomeInterleave or (b1 == nil or b1),
			dataUpdatedTimestamp = if not FFlagSduiChartsSupport and not FFlagEnableSduiV2HomeInterleave then nil else n2,
			configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else s2
		}
	end, {
		s1,
		v25,
		u27,
		if not FFlagSduiChartsSupport and not FFlagEnableSduiV2HomeInterleave then nil else n2,
		if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else s2,
		if not FFlagEnableSduiV2HomeInterleave then nil else b1
	}))
end

return useCreateClientBindingSduiContext
