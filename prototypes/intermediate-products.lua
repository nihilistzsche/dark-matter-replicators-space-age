data:extend({
  {
      type = "recipe",
      name = gprefix.."dark-matter-scoop",
      enabled = false,
      ingredients = {
        { name = gprefix..'tenemut', amount = 4, type = "item" },
        { name = 'iron-plate', amount = 1, type = "item" }
      },
      results = {
        { name = gprefix.."dark-matter-scoop", amount = 1, type = "item" }
      }
  },
  {
    type = "tool",
    name = gprefix.."dark-matter-scoop",
    icon = "__dark-matter-replicators-space-age__/graphics/icons/dark-matter-scoop.png",
	  icon_size = 64,
    subgroup = gprefix.."replication-resources",
    order = "a[matter-conduit]-a",
    stack_size = 200,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount"
  },
  {
      type = "recipe",
      name = gprefix.."dark-matter-transducer",
      enabled = false,
      ingredients = {
        {name = gprefix..'dark-matter-scoop', amount = 4, type = "item"},
        {name = 'steel-plate', amount = 1, type = "item"}
      },
      results = {
        { name = gprefix.."dark-matter-transducer", amount = 1, type = "item" }
      }
    },
  {
    type = "tool",
    name = gprefix.."dark-matter-transducer",
    icon = "__dark-matter-replicators-space-age__/graphics/icons/dark-matter-transducer.png",
	  icon_size = 64,
    subgroup = gprefix.."replication-resources",
    order = "a[matter-conduit]-b",
    stack_size = 200,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount"
  },
  {
      type = "recipe",
      name = gprefix.."matter-conduit",
      enabled = false,
      ingredients = {
        { name = gprefix..'dark-matter-transducer', amount = 4, type = "item" },
        { name = gprefix..'dark-matter-scoop', amount = 1, type = "item" }
      },
      results = {
        { name = gprefix.."matter-conduit", amount = 1, type = "item" }
      }
  },
  {
    type = "tool",
    name = gprefix.."matter-conduit",
    icon = "__dark-matter-replicators-space-age__/graphics/icons/matter-conduit.png",
	  icon_size = 64,
    subgroup = gprefix.."replication-resources",
    order = "a[matter-conduit]-c",
    stack_size = 200,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount"
  },
})