local parent = script:FindFirstAncestor("Moments").Parent
require(parent.MomentsTypes)
require(script.Parent.FeedTypes)

local function matches(moment, published): boolean -- 1 equivalent call inferred from this helper
	if published == nil then
		return false
	end

	local feedItemId = published.recommendationMetadata.feedItemId

	if moment.momentId == published.momentId then
		return true
	elseif feedItemId == nil or feedItemId == "" then
		return false
	else
		return moment.recommendationMetadata.feedItemId == feedItemId
	end
end

local function createPendingFeedOverlay()
	local v = {}
	local v2 = {}

	local function identity(p)
		if p.kind ~= "moment" then
			return nil
		end

		for k, v3 in v do
			if p.moment.momentId ~= k and not matches(p.moment, v3.published) then -- inferred equivalent call
				continue
			end

			return k
		end

		return p.moment.momentId
	end

	return {
		update = function(p, list)
			local v3 = false
			v2 = p

			for _, v4 in v2 do
				local moment = v4.moment
				local v5 = v[moment.momentId]

				if v5 == nil then
					v5 = { retired = false, admitted = false }
					v[moment.momentId] = v5
					v3 = true
				end

				if v4.publishedMoment ~= nil then
					v5.published = v4.publishedMoment
				end
			end

			for _, v4 in v do
				if not (v4.published ~= nil and table.find(list, v4.published.momentId) ~= nil) then
					continue
				end

				v4.retired = true
			end

			return v3
		end,
		retireMissing = function(items)
			local set = {}

			for _, item in items do
				local v3 = identity(item)

				if v3 ~= nil then
					set[v3] = true
				end
			end

			for k, v3 in v do
				if not v3.admitted or set[k] then
					continue
				end

				v3.retired = true
			end
		end,
		merge = function(items)
			for _, v3 in v do
				v3.admitted = false
			end

			local momentIdSet = {}

			for _, v3 in v2 do
				momentIdSet[v3.moment.momentId] = true
			end

			local set = {}

			for _, item in items do
				local v3 = identity(item)

				if v3 == nil then
					continue
				end

				set[v3] = true
				local v4 = v[v3]

				if v4 ~= nil and item.kind == "moment" and item.moment.momentId ~= v3 then
					v4.published = item.moment
				end
			end

			local result = {}
			local set2 = {}
			local function append(p)
				local v3 = identity(p)

				if v3 ~= nil then
					if set2[v3] then
						return
					end

					set2[v3] = true
				end

				table.insert(result, p)
			end

			for _, v3 in v2 do
				local moment = v3.moment
				local momentId = moment.momentId
				local v4 = v[momentId]

				if set[momentId] or v4.retired then
					continue
				end

				local v5 = {
					kind = "moment",
					moment = v4.published or moment
				}
				local v6 = identity(v5)

				if v6 == nil then
					table.insert(result, v5)
				elseif not set2[v6] then
					set2[v6] = true

					table.insert(result, v5)
				end

				v4.admitted = true
			end

			for _, item in items do
				local v3 = identity(item)
				local v4

				if v3 ~= nil then
					v4 = v[v3]
				end

				if v4 == nil or item.kind ~= "moment" then
					local v5 = identity(item)

					if v5 ~= nil then
						if set2[v5] then
							continue
						end

						set2[v5] = true
					end

					table.insert(result, item)
				elseif not v4.retired and (momentIdSet[v3] or item.moment.momentId ~= v3) then
					local published = v4.published or item.moment

					local v5 = published ~= item.moment and { kind = "moment", moment = published } or item
					local v6 = identity(v5)

					if v6 == nil then
						table.insert(result, v5)
					elseif not set2[v6] then
						set2[v6] = true

						table.insert(result, v5)
					end

					v4.admitted = true
				end
			end

			return result
		end,
		identity = identity
	}
end

return createPendingFeedOverlay
