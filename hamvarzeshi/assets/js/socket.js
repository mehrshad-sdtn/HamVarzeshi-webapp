import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
const createSocket = (gymId) => {
let channel = socket.channel(`comments:${gymId}`, {})
  channel.join()
    .receive("ok", resp => 
    { 
      //console.log(resp)
      renderComments(resp.comments);
    })
    .receive("error", resp => 
    { 
      console.log("Unable to join", resp) 
    })

  channel.on(`comments: ${gymId}:new`, renderComment)

  document.querySelector("#post-btn").addEventListener("click", () => {
     const content = document.querySelector("#text-area").value;

     channel.push("comment:add", { content: content})
  });

};


function renderComments(comments) {
    const renderedComments = comments.map(comment => {
      return commentTemplate(comment);
    });

    document.querySelector("#collection").innerHTML =
     renderedComments.join('');
}

//---

function renderComment(event) {
  const renderedComments = commentTemplate(event.comment);
  document.querySelector("#collection").innerHTML +=
  renderedComments;
}

//---

function commentTemplate(comment) {
  let email = 'Anonymous';
  if (comment.user) {
    email = comment.user.email
  }
  return `
    <li class= 
        "font-light text-sm bg-white 
        border border-gray-200 shadow-sm rounded-md px-4 py-2 mb-3 mx-8">
        <div class= "font-normal text-blue-500 my-2"> ${email}  </div>
        <hr>
        <div class= "my-2"> ${comment.content} </div>
    </li>`;
}

//--

window.createSocket = createSocket;
