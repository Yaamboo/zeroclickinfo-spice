package DDG::Spice::BigHuge;
#     ABSTRACT: Give the synonym, antonym, similar and related words of the query.

use DDG::Spice;

spice from => '([^/]+)/([^/]+)';
spice to => 'http://words.bighugelabs.com/api/2/{{ENV{DDG_SPICE_BIGHUGE_APIKEY}}}/$1/json?callback={{callback}}_$2';

triggers startend => "synonyms", "synonym", "antonyms", "antonym", "related", "similar";

handle query_lc => sub {
  my $term;
  my $callback;

  if (/^(synonyms?|antonyms?|related|similar)\s+(?:terms?|words?)?\s*(?:of|to|for)?\s*([\w\s]+)$/) {
    $callback = $1;
    $term = $2;
  } elsif (/^([\w\s]+)\s+(synonyms?|antonyms?|related|similar)/){
    $callback = $2;
    $term = $1;
  }
  
  if (defined $term) {
    use feature 'switch';
    given($callback) {
      when('synonyms') { $callback = 'synonym'; }
      when('antonyms') { $callback = 'antonym'; }
      default { $callback; }
    }
    return $term, $callback;
  }

  return;
};

1;
