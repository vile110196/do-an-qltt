using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace DoctorSkin.config
{
	public class Realtime : Hub
	{
		public void SendMessage(string user, string message)
		{
			// Gửi tin nhắn tới tất cả client đang kết nối
			Clients.All.broadcastMessage(user, message);
		}
	}
}