require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local function matches(p2, p3)
	if p3 == nil then
		return false
	end

	local feedItemId = p3.recommendationMetadata.feedItemId
	local v5

	if p2.momentId == p3.momentId then
		v5 = true
	elseif feedItemId == nil or feedItemId == "" then
		v5 = false
	else
		v5 = p2.recommendationMetadata.feedItemId == feedItemId
	end

	return v5
end

local function createPendingFeedOverlay()
	local v5 = {}
	local v6 = {}

	local function identity(p2)
		if p2.kind ~= "moment" then
			return nil
		end

		for k, v7 in v5 do
			if p2.moment.momentId == k then
				return k
			end

			local moment = p2.moment
			local published = v7.published
			local v8

			if published == nil then
				v8 = false
			else
				local feedItemId = published.recommendationMetadata.feedItemId

				if moment.momentId == published.momentId then
					v8 = true
				elseif feedItemId == nil or feedItemId == "" then
					v8 = false
				else
					v8 = moment.recommendationMetadata.feedItemId == feedItemId
				end
			end

			if not v8 then
				continue
			end

			return k
		end

		return p2.moment.momentId
	end

	return {
		update = function(p2, list)
			local v7 = false
			v6 = p2

			for k, v8 in v6 do
				local moment = v8.moment
				local v9 = v5[moment.momentId]

				if v9 == nil then
					v9 = { retired = false, admitted = false }
					v5[moment.momentId] = v9
					v7 = true
				end

				if v8.publishedMoment ~= nil then
					v9.published = v8.publishedMoment
				end
			end

			for k, v8 in v5 do
				if not (v8.published ~= nil and table.find(list, v8.published.momentId) ~= nil) then
					continue
				end

				v8.retired = true
			end

			return v7
		end,
		retireMissing = function(items)
			local set = {}

			for k, item in items do
				local v7 = identity(item)

				if v7 ~= nil then
					set[v7] = true
				end
			end

			for k, v7 in v5 do
				if not v7.admitted or set[k] then
					continue
				end

				v7.retired = true
			end
		end,
		merge = function(items)
			for k, v7 in v5 do
				v7.admitted = false
			end

			local momentIdSet = {}

			for k, v7 in v6 do
				momentIdSet[v7.moment.momentId] = true
			end

			local set = {}

			for k, item in items do
				local v7 = identity(item)

				if v7 == nil then
					continue
				end

				set[v7] = true
				local v8 = v5[v7]

				if v8 ~= nil and item.kind == "moment" and item.moment.momentId ~= v7 then
					v8.published = item.moment
				end
			end

			local result = {}
			local set2 = {}
			local function append(p2)
				local v7 = identity(p2)

				if v7 ~= nil then
					if set2[v7] then
						return
					end

					set2[v7] = true
				end

				table.insert(result, p2)
			end

			for k, v7 in v6 do
				local moment = v7.moment
				local momentId = moment.momentId
				local v8 = v5[momentId]

				if set[momentId] or v8.retired then
					continue
				end

				local v9 = {
					kind = "moment",
					moment = v8.published or moment
				}
				local v10 = identity(v9)

				if v10 == nil then
					table.insert(result, v9)
				elseif not set2[v10] then
					set2[v10] = true

					table.insert(result, v9)
				end

				v8.admitted = true
			end

			for k, item in items do
				local v7 = identity(item)
				local v8 = if v7 ~= nil then v5[v7] else nil

				if v8 == nil or item.kind ~= "moment" then
					local v9 = identity(item)

					if v9 ~= nil then
						if set2[v9] then
							continue
						end

						set2[v9] = true
					end

					table.insert(result, item)
				elseif not v8.retired and (momentIdSet[v7] or item.moment.momentId ~= v7) then
					local published = v8.published or item.moment

					local v9 = published ~= item.moment and {
						kind = "moment",
						moment = published
					} or item
					local v10 = identity(v9)

					if v10 == nil then
						table.insert(result, v9)
					elseif not set2[v10] then
						set2[v10] = true

						table.insert(result, v9)
					end

					v8.admitted = true
				end
			end

			return result
		end,
		identity = identity
	}
end

return createPendingFeedOverlay
