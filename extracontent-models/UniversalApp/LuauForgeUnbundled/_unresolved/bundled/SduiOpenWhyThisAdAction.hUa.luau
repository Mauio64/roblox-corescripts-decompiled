local module = require("@luauforge/bundled/hUb")
local module2 = require("@luauforge/bundled/hUc")
local module3 = require("@luauforge/bundled/hTY")
local sponsoredUserCohort = require("@luauforge/bundled/hUd").SponsoredUserCohort

local centralOverlayType = module2.CentralOverlayType
local sduiActionType = module3.SduiActionType
local sduiErrorType = module3.SduiErrors.SduiErrorType
local setCentralOverlay = module.Actions.SetCentralOverlay

local fFlagLuaAppSduiSponsoredOneByTwoTile = require("@luauforge/bundled/hTZ").FFlagLuaAppSduiSponsoredOneByTwoTile

local function reportInvalidParam(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.OpenWhyThisAd, message = p3, propName = p4 },
		p2.appPage
	)
end

local function SduiOpenWhyThisAdAction(p2, p3, p4, p5)
	local actionParams = if p2 then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenWhyThisAd,
				message = "Missing actionParams",
				propName = nil
			},
			p4.appPage
		)

		return
	end

	local universeId = actionParams.universeId
	local contentType = nil

	if fFlagLuaAppSduiSponsoredOneByTwoTile then
		contentType = actionParams.contentType

		if contentType == nil or contentType == "Game" or contentType == "AdLink" then
			local v5 = typeof(universeId) == "string" and universeId ~= ""
			local v6 = contentType == "AdLink" and (universeId == nil or universeId == "")

			if not (v5 or v6) then
				p4.dependencies.logger.reportError(
					sduiErrorType.InvalidActionParams,
					{
						name = sduiActionType.OpenWhyThisAd,
						message = "Missing or invalid actionParam: universeId",
						propName = "universeId"
					},
					p4.appPage
				)

				return
			end
		else
			local formatted = `Invalid actionParam: contentType ${contentType}`
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.OpenWhyThisAd,
					message = formatted,
					propName = "contentType"
				},
				p4.appPage
			)

			return
		end
	elseif typeof(universeId) ~= "string" or universeId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenWhyThisAd,
				message = "Missing or invalid actionParam: universeId",
				propName = "universeId"
			},
			p4.appPage
		)

		return
	end

	local payerName = actionParams.payerName

	if typeof(payerName) ~= "string" or payerName == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenWhyThisAd,
				message = "Missing or invalid actionParam: payerName",
				propName = "payerName"
			},
			p4.appPage
		)

		return
	end

	local sponsoredUserCohort2 = actionParams.sponsoredUserCohort
	local v5 = sponsoredUserCohort2 == nil

	if typeof(sponsoredUserCohort2) == "string" then
		for k, v7 in sponsoredUserCohort do
			if sponsoredUserCohort2 == v7 then
				v5 = true
				break
			end
		end
	end

	if v5 then
		local dispatch = p4.dependencies.dispatch
		local whyThisAdModal = centralOverlayType.WhyThisAdModal

		if not fFlagLuaAppSduiSponsoredOneByTwoTile then
			contentType = nil
		end

		dispatch(setCentralOverlay(whyThisAdModal, {
			universeId = universeId,
			payerName = payerName,
			sponsoredUserCohort = sponsoredUserCohort2,
			contentType = contentType
		}))
	else
		local formatted = `Invalid actionParam: sponsoredUserCohort ${sponsoredUserCohort2}`
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenWhyThisAd,
				message = formatted,
				propName = "sponsoredUserCohort"
			},
			p4.appPage
		)
	end
end

return SduiOpenWhyThisAdAction
