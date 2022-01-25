class TenjiMaker
  TENJI_MAP = {
    bo_in: {
      'A' => '- --',
      'K' => '- -o',
      'S' => 'o -o',
      'T' => 'o o-',
      'N' => '- o-',
      'H' => '- oo',
      'M' => 'o oo',
      'Y' => '-o -',
      'R' => 'o --',
      'W' => '-- -',
    },
    shi_in_having_five: {
      'A' => 'o- -',
      'I' => 'o- o',
      'U' => 'oo -',
      'E' => 'oo o',
      'O' => '-o o',
    },
    shi_in_not_having_five: {
      'A' => '- o-',
      'U' => '- oo',
      'O' => 'o o-',
    },
    you_on_with_sei_on: '-o -- --',
    you_on_with_daku_on: '-o -o --',
    you_on_with_han_daku_on: '-o -- -o',
    soku_on: '-- o- --',
    daku_on: '-- -o --',
    han_daku_on: '-- -- -o',
    hatsu_on: '-- -o oo',
    chou_on: '-- oo --',
  }

  SEION_MAP = {
    'G' => 'K',
    'Z' => 'S',
    'D' => 'T',
    'B' => 'H',
    'P' => 'H',
  }

  def to_tenji(text)
    tenjis_from(text).transpose.map { |column| column.join(' ') }.join("\n")
  end

  private

  def parse(char)
    case char.chars
    in [/[KSTNHMR]/ => sei_on, 'Y', *rests]
      [TENJI_MAP[:you_on_with_sei_on], parse([sei_on, *rests].join(''))]
    in [/[GZDB]/ => daku_on, 'Y', *rests]
      [TENJI_MAP[:you_on_with_daku_on], parse([SEION_MAP[daku_on], *rests].join(''))]
    in ['P' => han_daku_on, 'Y', *rests]
      [TENJI_MAP[:you_on_with_han_daku_on], parse([SEION_MAP[han_daku_on], *rests].join(''))]
    in [/[KSTNHMRWGZDB]/, /[KSTNHMRWGZDB]/ => soku_on, *rests]
      [TENJI_MAP[:soku_on], parse([soku_on, *rests].join(''))]
    in [/[KSTNHMR]/ => bo_in, shi_in]
      TENJI_MAP[:shi_in_having_five][shi_in] + TENJI_MAP[:bo_in][bo_in]
    in [/[YW]/ => bo_in, shi_in]
      TENJI_MAP[:bo_in][bo_in] + TENJI_MAP[:shi_in_not_having_five][shi_in]
    in [/[GZDB]/ => daku_on, *rests]
      [TENJI_MAP[:daku_on], parse([SEION_MAP[daku_on], *rests].join(''))]
    in ['P' => han_daku_on, *rests]
      [TENJI_MAP[:han_daku_on], parse([SEION_MAP[han_daku_on], *rests].join(''))]
    in ['N']
      TENJI_MAP[:hatsu_on]
    in ['-']
      TENJI_MAP[:chou_on]
    in [shi_in]
      TENJI_MAP[:shi_in_having_five][shi_in] + TENJI_MAP[:bo_in]['A']
    end
  end

  def tenjis_from(text)
    text.split(' ').map { |char| parse(char) }.flatten.map { |tenji| tenji.split(' ') }
  end
end
