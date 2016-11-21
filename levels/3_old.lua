return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.1",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 500,
  height = 50,
  tilewidth = 25,
  tileheight = 25,
  nextobjectid = 1157,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 25,
      tileheight = 25,
      spacing = 0,
      margin = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 14,
      tiles = {
        {
          id = 0,
          image = "E:/tiles/coinTile.png",
          width = 25,
          height = 25
        },
        {
          id = 1,
          image = "E:/tiles/darkTile.png",
          width = 25,
          height = 25
        },
        {
          id = 2,
          image = "E:/tiles/endGameTile.png",
          width = 25,
          height = 25
        },
        {
          id = 3,
          image = "E:/tiles/endZeroGravityTile.png",
          width = 25,
          height = 25
        },
        {
          id = 4,
          image = "E:/tiles/fatalTile.png",
          width = 25,
          height = 25
        },
        {
          id = 5,
          image = "E:/tiles/groundTile.png",
          width = 25,
          height = 25
        },
        {
          id = 6,
          image = "E:/tiles/lightTile.png",
          width = 25,
          height = 25
        },
        {
          id = 7,
          image = "E:/tiles/portal1Tile.png",
          width = 25,
          height = 25
        },
        {
          id = 8,
          image = "E:/tiles/portal2Tile.png",
          width = 25,
          height = 25
        },
        {
          id = 9,
          image = "E:/tiles/portal3Tile.png",
          width = 25,
          height = 25
        },
        {
          id = 10,
          image = "E:/tiles/portal4Tile.png",
          width = 25,
          height = 25
        },
        {
          id = 11,
          image = "E:/tiles/powerUpTile.png",
          width = 25,
          height = 25
        },
        {
          id = 12,
          image = "E:/tiles/spikeTile.png",
          width = 25,
          height = 25
        },
        {
          id = 13,
          image = "E:/tiles/startZeroGravityTile.png",
          width = 25,
          height = 25
        }
      }
    }
  },
  layers = {
    {
      type = "objectgroup",
      name = "Object Layer 1",
      visible = true,
      opacity = 1,
      offsetx = 166,
      offsety = 128,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 283,
          name = "",
          type = "G",
          shape = "rectangle",
          x = 25,
          y = 625,
          width = 1996.5,
          height = 25,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 994,
          name = "",
          type = "EG",
          shape = "rectangle",
          x = 1787.5,
          y = 631.25,
          width = 25,
          height = 400,
          rotation = 0,
          gid = 3,
          visible = true,
          properties = {}
        },
        {
          id = 1082,
          name = "",
          type = "C",
          shape = "rectangle",
          x = 500,
          y = 318.75,
          width = 25,
          height = 25,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1085,
          name = "",
          type = "G",
          shape = "rectangle",
          x = 25,
          y = 262.5,
          width = 1996.5,
          height = 25,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 1090,
          name = "",
          type = "C",
          shape = "rectangle",
          x = 806.25,
          y = 562.5,
          width = 25,
          height = 25,
          rotation = 0,
          gid = 1,
          visible = true,
          properties = {}
        },
        {
          id = 1091,
          name = "",
          type = "L",
          shape = "rectangle",
          x = 962.5,
          y = 381.25,
          width = 52.75,
          height = 121.75,
          rotation = 0,
          gid = 7,
          visible = true,
          properties = {}
        },
        {
          id = 1149,
          name = "",
          type = "G",
          shape = "rectangle",
          x = 293.75,
          y = 600,
          width = 52.75,
          height = 90.5,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 1150,
          name = "",
          type = "SZG",
          shape = "rectangle",
          x = 175,
          y = 600,
          width = 25,
          height = 340.5,
          rotation = 0,
          gid = 8,
          visible = true,
          properties = {}
        },
        {
          id = 1152,
          name = "",
          type = "G",
          shape = "rectangle",
          x = 525,
          y = 600,
          width = 52.75,
          height = 221.75,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 1153,
          name = "",
          type = "G",
          shape = "rectangle",
          x = 725,
          y = 481.25,
          width = 52.75,
          height = 221.75,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 1154,
          name = "",
          type = "G",
          shape = "rectangle",
          x = 962.5,
          y = 600,
          width = 52.75,
          height = 221.75,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 1155,
          name = "",
          type = "EZG",
          shape = "rectangle",
          x = 1187.5,
          y = 603.25,
          width = 25,
          height = 343.75,
          rotation = 0,
          gid = 4,
          visible = true,
          properties = {}
        },
        {
          id = 1156,
          name = "",
          type = "PU1",
          shape = "rectangle",
          x = 1306.25,
          y = 568.75,
          width = 25,
          height = 25,
          rotation = 0,
          gid = 12,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
