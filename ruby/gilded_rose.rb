# frozen_string_literal: true

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if item.name == 'Sulfuras, Hand of Ragnaros'

      item.sell_in -= 1
      if increases_in_value(item)
        increase_quality(item)
      else
        decrease_quality(item)
      end
    end
  end

  private

  def increase_quality(item)
    if item.quality < 50
      item.name == 'Aged Brie' ? change(item, 1) : backstage_passes(item)
    end
  end

  def decrease_quality(item)
    if item.quality.positive?
      item.name == 'Conjured' ? change(item, -2) : change(item, -1)
    end
  end

  def change(item, amount)
    item.quality += item.sell_in.negative? ? amount * 2 : amount
  end

  def increases_in_value(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert' || item.name == 'Aged Brie'
  end

  def backstage_passes(item)
    if item.sell_in.negative?
      item.quality = 0
    elsif item.sell_in.between?(0, 5)
      item.quality += 3
    elsif item.sell_in.between?(5, 10)
      item.quality += 2
    else
      item.quality += 1
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
