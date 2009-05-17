var utility = {
  //this will take a string template and use a hash as a map of key / value
  // search for the token of style ${something} where something will be used as the key in the value map.
	substitute: function(/*string*/ templ, /*object*/ map){
		return templ.replace(/\$\{([^\s\:\}]+)(?:\:([^\s\:\}]+))?\}/g, function(match, key, all){
		  return map[key];
		});
	}
}

var banana = {
  //template for standard row
	template_standard: '<li class=${is_new}><p class="message"> ${message} <span class="meta">~ ${committed_date_pretty} by ${author_name} - ${nice_id}</span></p></li>',

  //template for row with a branch label
	template_master: '<li class=${is_new}><em class="branch">${head}</em><p class="message"> ${message} <span class="meta">~ ${committed_date_pretty} by ${author_name} - ${nice_id}</span></p></li>',

  //fetch the index and use that to fetch json for each repository
	getData : function(){
		$.getJSON("/index.json", function(data) {
			$.each(data.repositories, function(i) {
				$.getJSON("/" + data.repositories[i].name + ".json", function(repository) {
				  banana.ajaxUpdate(repository);
				  $(".new").hide().fadeIn();
				});
			});
		}); 
	},
	
	already_exists: function(content, search_id){
	  return (content.indexOf(search_id)<0);
	},

  //use a repository data object to populate the repository information
	ajaxUpdate: function( /*object*/ repository) {
		var container = $("#" + repository.html_friendly_name + " .commits");
		var existing_content = container.get(0).innerHTML;
		var headBranch = null;
		var new_entries = [];
		var old_entries = [];
		$.each(repository.recent_commits, function(i) {
		  var commit = repository.recent_commits[i];
		  commit.author_name = commit.author.name;
		  commit.nice_id = commit.id.substr(0, 7);
		  commit.already_exists = banana.already_exists(existing_content, commit.nice_id);		  		  
		  commit.is_new = (commit.already_exists)?"new":"old";
		  var template = banana.template_standard;
		  if (commit.head) {
		    template = banana.template_master;
		  }
		  var messagePara = utility.substitute(template, commit);
		  if(commit.head){
		    headBranch = $(messagePara);
		  } else {
		    if(commit.already_exists){
		      new_entries.push(messagePara);
		    } else {
		      old_entries.push(messagePara);
  	    }
		  }
		});
    //clear out previous entries
    container.empty();
    if(headBranch) {
      container.append(headBranch)
    } 
    if(new_entries.length>0){
      container.append($(new_entries.join("")));
    }
    if(old_entries.length>0){
      container.append($(old_entries.join("")));
    }
	}
}