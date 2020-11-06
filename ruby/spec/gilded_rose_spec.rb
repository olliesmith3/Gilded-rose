# frozen_string_literal: true

require 'shop'
require 'item'

describe Shop do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      Shop.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    it 'The sell_in decreases by one for a normal item' do
      items = [Item.new('foo', 0, 0)]
      Shop.new(items).update_quality
      expect(items[0].sell_in).to eq(-1)
    end
  end

  describe 'Normal Items' do
    it 'For a normal item, the quality decreases by 1 if within sell by date' do
      items = [Item.new('foo', 1, 2)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 1
    end

    it 'For a normal item, the quality cannot go below 0' do
      items = [Item.new('foo', 1, 0)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 0
    end

    it 'For a normal item, the quality decreases by 2 if passed sell by date' do
      items = [Item.new('foo', 0, 5)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 3
    end
  end

  describe 'Aged Brie' do
    it 'Aged Brie increases in quality each day by 1 if within sell by date' do
      items = [Item.new('Aged Brie', 1, 0)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 1
    end

    it 'Aged Brie increases in quality each day by 2 if passed sell by date' do
      items = [Item.new('Aged Brie', 0, 0)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 2
    end

    it 'Aged Brie cannot increase above 50 quality' do
      items = [Item.new('Aged Brie', 2, 50)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 50
    end
  end

  describe 'Sulfuras' do
    it 'Sulfuras quality is 80 if sell_in > 0' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 2, 80)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 80
    end

    it 'Sulfuras quality is 80 if sell_in < 0' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', -50, 80)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 80
    end

    it 'Sulfuras sell_in does not change when above 0' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 80)]
      Shop.new(items).update_quality
      expect(items[0].sell_in).to eq 10
    end

    it 'Sulfuras sell_in does not change when below 0' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', -10, 80)]
      Shop.new(items).update_quality
      expect(items[0].sell_in).to eq(-10)
    end
  end

  describe 'Backstage Passes' do
    it 'Backstage passes increase in value by 1 when sell_in > 10' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 30)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 31
    end

    it 'Backstage passes increase in value by 2 when 50 > sell_in > 10' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 7, 30)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 32
    end

    it 'Backstage passes increase in value by 3 when 0 > sell_in > 5' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 3, 30)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 33
    end

    it 'Backstage passes decrease to 0 quality after sell by date' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 30)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 0
    end

    it 'Backstage passes cannot increase above 50 quality' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 2, 50)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 50
    end
  end

  describe 'Conjured items' do 
    it 'Conjured Items decrease by 4 when passed sell by date' do
      items = [Item.new('Conjured', 0, 30)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 26
    end

    it 'Conjured Items decrease by 2 when within sell by date' do
      items = [Item.new('Conjured', 10, 30)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 28
    end

    it 'For a Conjured item, the quality cannot go below 0' do
      items = [Item.new('Conjured', 1, 0)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 0
    end
  end

  describe 'Multiple items' do
    it 'if all item types are entered then the method still produces the results of other tests' do
      items = [Item.new('Conjured', 1, 0), Item.new('Backstage passes to a TAFKAL80ETC concert', 3, 30), Item.new('Sulfuras, Hand of Ragnaros', -10, 80), Item.new('Aged Brie', 0, 0), Item.new('foo', 1, 2)]
      Shop.new(items).update_quality
      expect(items[0].quality).to eq 0
      expect(items[1].quality).to eq 33
      expect(items[2].quality).to eq 80
      expect(items[3].quality).to eq 2
      expect(items[4].quality).to eq 1
    end
  end
end
