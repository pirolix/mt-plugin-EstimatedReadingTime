package MT::Plugin::OMV::EstimatedReadingTime;

use strict;
use MT 4;
use MT::Util;

use vars qw( $NAME $VERSION );
$NAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '0.01';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $NAME,
    key => $NAME,
    name => $NAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    doc_link => 'http://www.magicvox.net/archive/2010/11032033/',
    description => <<'HTMLHEREDOC',
<__trans phrase="Funtion tag to estimate the time which visitor read an article.">
HTMLHEREDOC
    l10n_class => $NAME. '::L10N',
    blog_config_template => 'tmpl/config.tmpl',
    settings => new MT::PluginSettings ([
        ['speed', { Default => 500, Scope => 'blog' }],
        ['cnt_title', { Default => 1, Scope => 'blog' }],
        ['cnt_body', { Default => 1, Scope => 'blog' }],
        ['cnt_more', { Default => 1, Scope => 'blog' }],
        ['opt_remove_html', { Default => 1, Scope => 'blog' }],
        ['phrase_0', { Default => 'You can read with a moment', Scope => 'blog' }],
        ['phrase_n', { Default => 'You can read while %d minutes', Scope => 'blog' }],
    ]),
    registry => {
        tags => {
            function => {
                $NAME => \&_tag_estimated_reading_time,
            },
        },
    },
});
MT->add_plugin ($plugin);

sub instance { $plugin; }

###
sub _tag_estimated_reading_time {
    my ($ctx, $args) = @_;

    my $e = $ctx->stash ('entry')
        or return $ctx->_no_entry_error;
    my $scope = 'blog:'. $e->blog_id;

    my $str;
    $str .= $e->title       if &instance->get_config_value ('cnt_title', $scope);
    $str .= $e->text        if &instance->get_config_value ('cnt_body', $scope);
    $str .= $e->text_more   if &instance->get_config_value ('cnt_more', $scope);
    $str = MT::Util::remove_html ($str)
        if &instance->get_config_value ('opt_remove_html', $scope);

    my $speed = &instance->get_config_value ('speed', $scope)
        or return ''; # divided by 0
    my $time = int ((length $str) / $speed + 0.5); # round off

    $time
        ? sprintf &instance->get_config_value ('phrase_n', $scope) || '', $time
        :         &instance->get_config_value ('phrase_0', $scope) || '';
}

1;