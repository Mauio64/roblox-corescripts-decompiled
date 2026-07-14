local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local MomentsCommon = require(Parent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local CreationFlowSteps = FunnelEventNames.CreationFlowSteps
local t1 = {
	[EventNames.MomentsEditingFlowContinueToEditButtonPressed] = CreationFlowSteps.GalleryItemSelectedContinuePressed,
	[EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed] = CreationFlowSteps.EditingScreenContinuePressed,
	[EventNames.MomentsEditingFlowPublished] = CreationFlowSteps.Published,
	[EventNames.EditingFlowGalleryPageAppear] = CreationFlowSteps.CreateIntent,
	[EventNames.EditingFlowEditPageAppear] = CreationFlowSteps.GalleryItemSelectedContinuePressed,
	[EventNames.EditingFlowPreviewPageAppear] = CreationFlowSteps.EditingScreenContinuePressed,
	[EventNames.MomentsEditingFlowExited] = CreationFlowSteps.CreateIntent
}
local t2 = {
	Gallery = CreationFlowSteps.GalleryItemSelectedContinuePressed,
	Preview = CreationFlowSteps.EditingScreenContinuePressed,
	Description = CreationFlowSteps.EditingScreenContinuePressed
}

return {
	makeStepField = function(s1: string) -- line: 79
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy), t1 (copy)
		if not GetFFlagMomentsAnalyticsProducerPrereqs() then
			return {}
		end

		local v10 = t1[s1]

		if v10 == nil then
			return {}
		end

		return {
			step = v10
		}
	end,
	makeStepFieldFromState = function(s2: string?) -- line: 92
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy), t2 (copy)
		if not GetFFlagMomentsAnalyticsProducerPrereqs() then
			return {}
		end

		local v12 = if s2 == nil then nil else t2[s2]

		if v12 == nil then
			return {}
		end

		return {
			step = v12
		}
	end,
	makeToolField = function(t3: {[any]: any}?) -- line: 104
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy)
		if not GetFFlagMomentsAnalyticsProducerPrereqs() then
			return {}
		end

		if t3 == nil or t3.kind == nil then
			return {}
		end

		return {
			tool = t3.kind
		}
	end,
	makeToolFieldFromKind = function(s3: string?) -- line: 116
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy)
		if not GetFFlagMomentsAnalyticsProducerPrereqs() then
			return {}
		end

		if s3 == nil then
			return {}
		end

		return {
			tool = s3
		}
	end,
	makeCreationBaseFields = function(s4: string?) -- line: 133
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy)
		if not GetFFlagMomentsAnalyticsProducerPrereqs() then
			return {}
		end

		if s4 == nil then
			return {}
		end

		return {
			creationSessionId = s4
		}
	end,
	makeCaptureDescriptorFields = function(p1) -- line: 167
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy)
		local t4 = {
			sourcePlaceId = tostring(p1.SourcePlaceId),
			localId = tostring(p1.LocalId)
		}
		local CaptureType = p1.CaptureType

		t4.captureType = if typeof(CaptureType) ~= "EnumItem" then if CaptureType ~= nil then tostring(CaptureType) else nil else CaptureType.Name

		if GetFFlagMomentsAnalyticsProducerPrereqs() then
			t4.universeId = tostring(p1.SourceUniverseId)
		end

		return t4
	end,
	enumName = function(p2) -- line: 148
		if typeof(p2) == "EnumItem" then
			return p2.Name
		end

		if p2 == nil then
			return nil
		end

		return (tostring(p2))
	end
}
