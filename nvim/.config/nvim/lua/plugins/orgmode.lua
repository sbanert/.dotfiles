return {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function ()
        require("orgmode").setup()
    end,
}
