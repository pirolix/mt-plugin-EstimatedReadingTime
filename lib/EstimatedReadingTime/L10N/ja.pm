package EstimatedReadingTime::L10N::ja;
# $Id$

use strict;
use base 'EstimatedReadingTime::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Funtion tag to estimate the time which visitor read an article.' => '訪問者が記事を読むのにかかる時間を見積もる変数タグを提供します。',
    'Counting' => '計数',
    'Option' => 'オプション',
    'Reading Speed' => '読取り速度',
    'Output Phrase' => '出力文字列',
    'Ignore HTML tags' => 'HTMLタグを無視する',
    'characters per minute' => '文字(1分あたり)',
    'When the estimated time is less than a minute.' => '読み取り時間が1分未満の時：',
    'When the estimated time is a few minutes. %d will be relaced into the figures.' => '読み取り時間が数分以上の時(%dは数値に置き換えられます)：',
);

1;