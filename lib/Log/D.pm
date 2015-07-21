#require(Exporter);

#@ISA = qw(Exporter);

#@EXPORT =
#  qw(dprint dban);

unit class Log::D;
#our  %allowonly; 

has $.enablee is rw;
has $.enablew is rw;
has $.enablei is rw;
has $.enabled is rw;
has $.enablev is rw;
has $.enablep is rw;


has $.enablees is rw;
has $.enablews is rw;
has $.enableis is rw;
has $.enableds is rw;
has $.enablevs is rw;
has $.enableps is rw;

has %bans;

has %allowonly;

has $.o is rw;

has &.prefix is rw;

has $.notify;

method new($output?,:$e,:$w,:$i,:$d,:$v,:$p)
{
  self.bless(o=> $output // $*ERR, enablee => $e,enablew => $w,enablei => $i,enabled => $d,enablev => $v, enablep => $p,
  enablees => $e,enablews => $w,enableis => $i,enableds => $d,enablevs => $v, enableps => $p, prefix => sub { return ""}
  );

}

method enable(*%e)
{
  for %e.kv  -> $k,$v {
   given ($k)
   {
     when "e" {  $!enablee = $v;  $!enablees = $v;}
     when "w" {  $!enablew = $v;  $!enablews = $v;}
     when "i" {  $!enablei = $v;  $!enableis = $v;}
     when "d" {  $!enabled = $v;  $!enableds = $v;}
     when "v" {  $!enablev = $v;  $!enablevs = $v;}
     when "p" {  $!enablep = $v;  $!enableps = $v;}  
   } 
  }
}

method allow($section)
{
  if $section eq ""
  {
     $!enablees = $!enablee;
     $!enablews = $!enablew;
     $!enableis = $!enablei;
     $!enableds = $!enabled;
     $!enablevs = $!enablev;
     $!enableps = $!enablep;
  }
  else
  {
    %allowonly{$section} = True;
    %bans{$section}:delete;
  }
  if ($!notify)
  {
    say $!o: callframe(1).file~" "~callframe(1).line~" d log allowing >$section\<";
  }
  
}

method remove_allow($section)
{
  if $section eq ""
  {
  }
  else
  {
    %allowonly{$section}:delete; 
  }
  if ($!notify)
  {
    say $!o: callframe(1).file~" "~callframe(1).line~" d log removes allow of >$section\<";
  }
}

method ban($section)
{
if $section eq ""
  {
     $!enablees =  False;
     $!enablews =  False;
     $!enableis =  False;
     $!enableds =  False;
     $!enablevs =  False;
     $!enableps =  False;
  }
  else
  {
     %bans{$section} = True;
     %allowonly{$section}:delete; 
  }
  if ($!notify)
  {
    say $!o: callframe(1).file~" "~callframe(1).line~" d log bans $section\<";
  }
}


method remove_ban($section)
{
if $section eq ""
  {
     $!enablees = $!enablee;
     $!enablews = $!enablew;
     $!enableis = $!enablei;
     $!enableds = $!enabled;
     $!enablevs = $!enablev;
     $!enableps = $!enablep;
  }
  else
  {
     %bans{$section} = True;
     %allowonly{$section}:delete; 
  }
  
  if ($!notify)
  {
    say $!o: callframe(1).file~" "~callframe(1).line~" d log removes ban on $section\<";
  }
}

multi method e($message) 
{
 say $!o: &!prefix()~"error:"~$message if $.enablews;
}

multi method e($section,$message) 
{
 if (!%bans.EXISTS-KEY($section) && (!%allowonly || (%allowonly.EXISTS-KEY($section))))
 {
   say $!o: &!prefix()~"<$section> error:"~$message if $.enablew;
 }
}

multi method w($message) 
{
 say $!o: &!prefix()~"warning:"~$message if $.enablews;
}

multi method w($section,$message) 
{
 if (!%bans.EXISTS-KEY($section) && (!%allowonly || (%allowonly.EXISTS-KEY($section))))
 {
 say $!o: &!prefix()~"<$section> warning:"~$message if $.enablew;
 }
}

multi method i($message) 
{
 say $!o: &!prefix()~"info:"~$message if $.enableis;
}

multi method i($section,$message) 
{
 if (!%bans.EXISTS-KEY($section) && (!%allowonly || (%allowonly.EXISTS-KEY($section))))
 {
  say $!o: &!prefix()~"<$section> info:"~$message if $.enablei;
 } 
 
}

multi method d($message) 
{
 
 say $!o: &!prefix()~"debug:"~$message if $.enableds;
 
}

multi method d($section,$message) 
{
 if (!%bans.EXISTS-KEY($section) && (!%allowonly || (%allowonly.EXISTS-KEY($section))))
 {
 say $!o: &!prefix()~"<$section> debug:"~$message if $.enabled;
 }
}

multi method v($message) 
{  
  say $!o: &!prefix()~"verbose:"~$message if $.enablevs;
}

multi method v($section,$message) 
{
 if (!%bans.EXISTS-KEY($section) && (!%allowonly || (%allowonly.EXISTS-KEY($section))))
 {
  say $!o: &!prefix()~"<$section> verbose:"~$message if $.enablev;
  }
}

multi method p($message) 
{
  say $!o: &!prefix()~$message if $.enableps;
}

multi method p($section,$message) 
{
 if (!%bans.EXISTS-KEY($section) && (!%allowonly || (%allowonly.EXISTS-KEY($section))))
 {
  say $!o: &!prefix()~"<$section> $message" if $.enablep;
  }
}

