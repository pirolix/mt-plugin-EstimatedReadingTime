package MT::Plugin::OMV::EstimatedReadingTime;
# $Id$

use strict;
use MT 4;
use MT::Util;

use vars qw( $VENDOR $MYNAME $VERSION );
($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1];
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = '0.01'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $MYNAME,
    key => $MYNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    doc_link => 'http://www.magicvox.net/archive/2010/11032033/',
    plugin_link => 'http://lab.magicvox.net/trac/mt-plugins/wiki/EstimatedReadingTime',
    description => <<'HTMLHEREDOC',
<__trans phrase="Funtion tag to estimate the time which visitor read an article.">
HTMLHEREDOC
    l10n_class => "${MYNAME}::L10N",
    blog_config_template => "tmpl/$MYNAME/config.tmpl",
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
                $MYNAME => \&_tag_estimated_reading_time,
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
    my $time = ((length $str) / $speed + 0.5); # round off

    $time
        ? sprintf &instance->get_config_value ('phrase_n', $scope) || '', $time
        :         &instance->get_config_value ('phrase_0', $scope) || '';
}

1;
