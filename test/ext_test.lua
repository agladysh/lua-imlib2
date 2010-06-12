require("lunit")

local imlib2 = require("imlib2")
local module = module

local math = math

module("bounding rect by alpha", lunit.testcase)

function test_empty()
  local im = imlib2.image.new(128, 256)
  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 1)
  assert_equal(0, x, "x")
  assert_equal(0, y, "y")
  assert_equal(0, w, "w")
  assert_equal(0, h, "h")
end

function test_full()
  local im = imlib2.image.new(128, 256)
  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 0)
  assert_equal(0, x, "x")
  assert_equal(0, y, "y")
  assert_equal(128, w, "w")
  assert_equal(256, h, "h")
end

function test_partial_square()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(10, 10, 110, 220, imlib2.color.new(0, 0, 0, 1))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 1)

  assert_equal(10, x, "x")
  assert_equal(10, y, "y")
  assert_equal(110, w, "w")
  assert_equal(220, h, "h")
end

function test_partial_pixel_cloud()
  local color = imlib2.color.new(0, 0, 0, 2)

  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)

  local min_x, max_x, min_y, max_y = math.huge, -1, math.huge, -1
  for i = 1, 100 do
    local x = math.random(0, 127)
    local y = math.random(0, 255)

    im:draw_pixel(x, y, color)

    min_x = math.min(min_x, x)
    max_x = math.max(max_x, x)
    min_y = math.min(min_y, y)
    max_y = math.max(max_y, y)
  end

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 1)

  assert_equal(min_x, x, "x")
  assert_equal(min_y, y, "y")
  assert_equal(max_x - min_x + 1, w, "w")
  assert_equal(max_y - min_y + 1, h, "h")
end

function test_single_bottom_left()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:draw_pixel(0, 0, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 1)

  assert_equal(0, x, "x")
  assert_equal(0, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

function test_single_bottom_right()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:draw_pixel(127, 0, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 1)

  assert_equal(127, x, "x")
  assert_equal(0, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

function test_single_bottom_left()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:draw_pixel(0, 255, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 1)

  assert_equal(0, x, "x")
  assert_equal(255, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

function test_single_bottom_right()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:draw_pixel(127, 255, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 1)

  assert_equal(127, x, "x")
  assert_equal(255, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

function test_single_middle_with_gray()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:draw_pixel(27, 27, imlib2.color.new(0, 0, 0, 2))
  im:draw_pixel(28, 28, imlib2.color.new(0, 0, 0, 1))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_alpha_threshold(im, 2)

  assert_equal(27, x, "x")
  assert_equal(27, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

module("bounding rect by empty color", lunit.testcase)

function test_empty()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(0, 0, 0, 0))
  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(0, 0, 0, 0)
    )
  assert_equal(0, x, "x")
  assert_equal(0, y, "y")
  assert_equal(0, w, "w")
  assert_equal(0, h, "h")
end

function test_full()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(0, 0, 0, 0))
  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(1, 2, 3, 4)
    )
  assert_equal(0, x, "x")
  assert_equal(0, y, "y")
  assert_equal(128, w, "w")
  assert_equal(256, h, "h")
end

function test_partial_square()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(255, 255, 255, 1))
  im:fill_rectangle(10, 10, 110, 220, imlib2.color.new(255, 255, 255, 200))
  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(255, 255, 255, 1)
    )
  assert_equal(10, x, "x")
  assert_equal(10, y, "y")
  assert_equal(110, w, "w")
  assert_equal(220, h, "h")
end

function test_partial_pixel_cloud()
  local color = imlib2.color.new(0, 0, 0, 2)

  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(0, 0, 0, 0))

  local min_x, max_x, min_y, max_y = math.huge, -1, math.huge, -1
  for i = 1, 100 do
    local x = math.random(0, 127)
    local y = math.random(0, 255)

    im:draw_pixel(x, y, color)

    min_x = math.min(min_x, x)
    max_x = math.max(max_x, x)
    min_y = math.min(min_y, y)
    max_y = math.max(max_y, y)
  end

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(0, 0, 0, 0)
    )

  assert_equal(min_x, x, "x")
  assert_equal(min_y, y, "y")
  assert_equal(max_x - min_x + 1, w, "w")
  assert_equal(max_y - min_y + 1, h, "h")
end

function test_single_bottom_left()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(0, 0, 0, 0))
  im:draw_pixel(0, 0, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(0, 0, 0, 0)
    )

  assert_equal(0, x, "x")
  assert_equal(0, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

function test_single_bottom_right()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(0, 0, 0, 0))
  im:draw_pixel(127, 0, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(0, 0, 0, 0)
    )

  assert_equal(127, x, "x")
  assert_equal(0, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

function test_single_bottom_left()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(0, 0, 0, 0))
  im:draw_pixel(0, 255, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(0, 0, 0, 0)
    )

  assert_equal(0, x, "x")
  assert_equal(255, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end

function test_single_bottom_right()
  local im = imlib2.image.new(128, 256)
  im:set_alpha(true)
  im:fill_rectangle(0, 0, 128, 256, imlib2.color.new(0, 0, 0, 0))
  im:draw_pixel(127, 255, imlib2.color.new(0, 0, 0, 2))

  local x, y, w, h = imlib2.ext.get_bounding_rect_by_empty_color(
      im,
      imlib2.color.new(0, 0, 0, 0)
    )

  assert_equal(127, x, "x")
  assert_equal(255, y, "y")
  assert_equal(1, w, "w")
  assert_equal(1, h, "h")
end
