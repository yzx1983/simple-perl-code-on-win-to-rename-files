use Encode;

my $count=0;
my($file);
my $root_dir="G:/LastF";
my $dir_str="G:\\LastF";

my $chstr="电话";
$chstr=decode("utf8",$chstr);
$chstr=encode("gbk",$chstr);

opendir(D, $root_dir); 
open(cmdFile,">","cmd.bat");
while (($file = readdir D) && ($count < 1)) { 
  next if ($file =~/^\.\.?$/);
  
  #next if ($file =~/^\D.+/);
  $old_name = $dir_str . "\\" . $file; 

  
#  $file=decode("gbk",$file);
  #print "$file\n" if ($file ne "." && $file ne ".."); 
  #$file_utf8=encode("utf8",$file);
  #Encode::_utf8_on($file_utf8);
  next if !($file =~ /$chstr\d+(.+)$/); #/^\W+13588863367\W+$/ ;
#  $w1 = $1;
#  $w2 = encode("gbk",$w1);
#  $w2 =~ /\d+(.+)$/;

  print "old name : $old_name\n";
  $new_name = $1; /* This may be a potential bug , if previous pattern not matched this string , $1 will leave stale value. */
  print "new name : $new_name \n";
  print cmdFile "rename \"$old_name\" \"$new_name\"\n"; /* since sometimes it needs "administrator" role to do rename , create a bat file so later you can run it with administrator role */
  @args = ("rename","\"$old_name\"","\"$new_name\"");
  system(@args) == 0 ; #or die "system @args failed: $?" ;
  if ($? != 0) {
    $newFile = $root_dir . "/" . $new_name;
    print "The full name is $newFile \n";
    if (-e $newFile) {
      print "Exist .\n";
      $newFile = $dir_str . "\\" . "$new_name";
      @rmArgs = ("del","$newFile");
      system(@rmArgs);
      system(@args);
      if ($? != 0) {
        exit;
      }
    }
  }
  $new_name=""; /* This is to try to avoid the bug however it actually should not work ...*/
  $count;
}

close cmdFile;
