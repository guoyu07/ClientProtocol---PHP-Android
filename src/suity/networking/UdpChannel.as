package suity.networking 
{
	
	/**
	 * ...
	 * @author Simage
	 */
	public class UdpChannel 
	{
        /// <summary>
        /// Messages are not guaranteed to arrive
        /// </summary>
        public static const Unreliable:int = 0;

        /// <summary>
        /// Messages are not guaranteed to arrive; but out-of-order message; ie. late messages; are dropped
        /// </summary>
        public static const UnreliableInOrder1:int = 1;
        public static const UnreliableInOrder2:int = 2;
        public static const UnreliableInOrder3:int = 3;
        public static const UnreliableInOrder4:int = 4;
        public static const UnreliableInOrder5:int = 5;
        public static const UnreliableInOrder6:int = 6;
        public static const UnreliableInOrder7:int = 7;
        public static const UnreliableInOrder8:int = 8;
        public static const UnreliableInOrder9:int = 9;
        public static const UnreliableInOrder10:int = 10;
        public static const UnreliableInOrder11:int = 11;
        public static const UnreliableInOrder12:int = 12;
        public static const UnreliableInOrder13:int = 13;
        public static const UnreliableInOrder14:int = 14;
        public static const UnreliableInOrder15:int = 15;

        /// <summary>
        /// Messages are guaranteed to arrive; but not necessarily in the same order as they were sent
        /// </summary>
        public static const ReliableUnordered:int = 16;

        /// <summary>
        /// Messages are guaranteed to arrive; in the same order as they were sent
        /// </summary>
        public static const ReliableInOrder1:int = 17;
        public static const ReliableInOrder2:int = 18;
        public static const ReliableInOrder3:int = 19;
        public static const ReliableInOrder4:int = 20;
        public static const ReliableInOrder5:int = 21;
        public static const ReliableInOrder6:int = 22;
        public static const ReliableInOrder7:int = 23;
        public static const ReliableInOrder8:int = 24;
        public static const ReliableInOrder9:int = 25;
        public static const ReliableInOrder10:int = 26;
        public static const ReliableInOrder11:int = 27;
        public static const ReliableInOrder12:int = 28;
        public static const ReliableInOrder13:int = 29;
        public static const ReliableInOrder14:int = 30;
        public static const ReliableInOrder15:int = 31;
	}
	
}