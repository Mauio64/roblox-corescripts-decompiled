local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local React = require(SduiCoreSystemParent.React)
local Signals = require(SduiCoreSystemParent.Signals)
local SignalsReact = require(SduiCoreSystemParent.SignalsReact)
local tutils = require(SduiCoreSystemParent.tutils)
local compareSduiProps = require(SduiCoreSystem.compareSduiProps)
local SduiErrorType = require(SduiCoreSystem.SduiErrors).SduiErrorType

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)
require(SduiCoreSystem.SduiComponentType)

local getSduiComponentRegistry = require(SduiCoreSystem.getSduiComponentRegistry)
local validateInterface = require(SduiCoreSystem.validateInterface)
local FFlagSduiNestedComponentListProp = require(SduiCoreSystemParent.SharedFlags).FFlagSduiNestedComponentListProp
local FFlagSduiPoolBackedFeed = require(SduiCoreSystemParent.SharedFlags).FFlagSduiPoolBackedFeed
local v13 = game:DefineFastFlag("SduiDataBindingShallowEquals", false)

local function SduiErrorComponent(_) -- line: 25
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local t1 = {}

local function buildWrappedComponent(p2: ((...any) -> ...any), p3, t2: {[any]: any}?) -- line: 42
	-- upvalues: FFlagSduiNestedComponentListProp (copy), t1 (copy), React (copy), getSduiComponentRegistry (copy), SduiErrorType (copy), SduiErrorComponent (copy), validateInterface (copy)
	local componentType = p3.componentConfig.componentType
	local sduiContext = p3.sduiContext

	if p3.localAnalyticsData then
		p3.componentConfig.analyticsContext.setLocalAnalyticsData(p3.localAnalyticsData)
	end

	local v24 = if not p3.componentConfig.props then {} else table.clone(p3.componentConfig.props)
	local v25 = if not FFlagSduiNestedComponentListProp or not p3.componentConfig.nestedComponentConfigListPropSignalNames then t1 else p3.componentConfig.nestedComponentConfigListPropSignalNames

	if t2 then
		for v26, v27 in t2 do
			if not v27.isNestedComponentConfig and (not FFlagSduiNestedComponentListProp or not v25[v26]) then
				v24[v26] = v27.data
			end
		end
	end

	if p3.extraLocalProps then
		for v28, v29 in p3.extraLocalProps do
			v24[v28] = v29
		end
	end

	v24.componentConfig = p3.componentConfig
	v24.sduiContext = p3.sduiContext
	v24.debugName = p3.debugName
	v24.analyticsContext = p3.componentConfig.analyticsContext

	local v30 = nil

	if t2 then
		for v31, v32 in t2 do
			if v32.isNestedComponentConfig then
				if v30 == nil then
					v30 = if not p3.componentConfig.nestedComponentConfigs then {} else table.clone(p3.componentConfig.nestedComponentConfigs)
				end

				v30[v31] = v32.data
			end
		end
	end

	local v33 = v30 or p3.componentConfig.nestedComponentConfigs

	if v33 then
		for v34, v35 in v33 do
			local v36 = p2(v35)

			v24[v34] = React.createElement(v36, {
				sduiContext = p3.sduiContext,
				componentConfig = v35,
				debugName = `{ p3.debugName }.{ v34 }`
			})
		end
	end

	if FFlagSduiNestedComponentListProp and t2 and next(v25) then
		for v37 in v25 do
			local v38 = t2[v37]

			if v38 then
				local data = v38.data

				if data then
					local t3 = {}

					for v41, v42 in data do
						local v43 = p2(v42)

						t3[`{ v37 }_{ v41 }_{ v42.componentType }`] = React.createElement(v43, {
							sduiContext = p3.sduiContext,
							componentConfig = v42,
							extraLocalProps = {
								layoutOrder = v41
							},
							debugName = `{ p3.debugName }.{ v37 }[{ v41 }]`
						})
					end

					v24[v37] = t3
				end
			end
		end
	end

	local v44 = getSduiComponentRegistry().getComponentDefinition(componentType)
	local v45 = v44 and v44.component or nil

	if v45 == nil then
		sduiContext.dependencies.logger.reportError(SduiErrorType.NoComponentRegistered, {
			componentType = componentType,
			name = p3.debugName
		}, sduiContext.appPage)

		return React.createElement(SduiErrorComponent)
	end

	local v46 = v44 and v44.propInterface

	if v46 and not validateInterface(v24, v46) then
		return nil
	end

	return React.createElement(v45, v24)
end
local function createSduiClientBindingWrappers(p4: ((...any) -> ...any)) -- line: 171
	-- upvalues: React (copy), buildWrappedComponent (copy), compareSduiProps (copy), FFlagSduiPoolBackedFeed (copy), Signals (copy), v13 (copy), tutils (copy), SignalsReact (copy)
	local v48 = React.memo(function(p5) -- line: 177
		-- upvalues: buildWrappedComponent (copy), p4 (copy)
		return buildWrappedComponent(p4, p5)
	end, compareSduiProps)
	local v49 = React.memo(function(p6) -- line: 183
		-- upvalues: FFlagSduiPoolBackedFeed (copy), React (copy), Signals (copy), v13 (copy), tutils (copy), SignalsReact (copy), buildWrappedComponent (copy), p4 (copy)
		local propSignals = p6.componentConfig.propSignals
		local isComponentFilteredSignal = p6.componentConfig.isComponentFilteredSignal
		local v54 = if not FFlagSduiPoolBackedFeed then nil else p6.extraLocalPropSignals
		local v55 = React.useMemo(function() -- line: 191
			-- upvalues: propSignals (copy), isComponentFilteredSignal (copy), v54 (copy), Signals (copy), FFlagSduiPoolBackedFeed (copy), v13 (copy), tutils (copy)
			assert(propSignals or (isComponentFilteredSignal or v54), "propSignals, isComponentFilteredSignal, or extraLocalPropSignals must exist")

			return Signals.createComputed(function(p7) -- line: 196
				-- upvalues: propSignals (copy), FFlagSduiPoolBackedFeed (copy), v54 (copy), isComponentFilteredSignal (copy)
				local t4 = {}

				if propSignals then
					for v59, v60 in propSignals do
						t4[v59] = v60(p7)
					end
				end

				if FFlagSduiPoolBackedFeed and v54 then
					for v61, v62 in v54 do
						t4[v61] = {
							data = v62(p7)
						}
					end
				end

				if isComponentFilteredSignal and isComponentFilteredSignal(p7).data == true then
					t4.__isComponentFiltered = true
				end

				return t4
			end, if not v13 then nil else tutils.shallowEqual)
		end, {
			propSignals,
			isComponentFilteredSignal,
			if not FFlagSduiPoolBackedFeed then nil else v54,
			p6.componentConfig.componentType
		})
		local v56 = SignalsReact.useSignalState(v55)

		if v56.__isComponentFiltered == true then
			return nil
		end

		return buildWrappedComponent(p4, p6, v56)
	end, compareSduiProps)

	return {
		SduiClientBindingThinWrapper = v48,
		SduiDataBindingWrapper = v49
	}
end

return createSduiClientBindingWrappers
